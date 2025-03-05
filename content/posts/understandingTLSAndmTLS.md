+++
title = 'understandingTLSAndmTLS'
date = 2024-11-22T11:00:48-08:00
draft = false
+++

This blog is mostly to deepen my understanding of TLS and mTLS. A broad overview of why TLS is easily googleable but to give my understanding of it, two things need to talk to each other. If you talk unencrypted on the internet, things evesdrop, as well as can modify the conversation. TLS adds a way to stop that.

## How it works

So for TLS there are three essential components.

* A CA bundle: This is the information about some autority that is globally known that acts as a source of truth.
* A server certificate: This is the public identity of the server. This cert also contains a public key. Let's call it `server-pub-key`.
* A server private key: This is just a private key of the server.

### The CA bundle

The CA bundle is a set of information about a certificate autority. This bundle has a bunch of information, but the most import to us is the public key. The CA bundle will have the public key of some super trusted autority. Let's call this public key, `ca-pub-key`.

### The server cert

The server cert is a certificate that the server gets from the CA. Let's for now treat this processes as a black box, but the idea is:

* The server talks to the CA, and gives it a proof of it's identity, along with a public key (`server-pub-key`).
* The CA verifies this request from the server.
* Then the CA puts this info along with the `server-pub-key` in a structure (this is a predefined structure, you can think of it like a json with a bunch of info).
* The CA then signs this structure with it's private key (say`ca-private-key`). And returns this cert to the server.

This process creates a `server-cert`.

### The server private key

In the cert creation processes the server sends a public key to the CA. The server private key is the currosponding private key of the server (say `server-private-key`). This private key is very securly stored with the server.

## Now the flow of how it all works

The flow of TLS is very simple. A client wants to talk to a server, so the client initiates a connection with a server. This processes is:

* When client creates a connection request with the server.
* The server sends the client the `server-cert`.
* First the client will verify that this `server-cert` is valid by checking it's signature with the CA that the client has.
* Then the client will start a key exchange processes.
  * This key exchange, is encrypted with the `server-pub-key` present in the cert.
  * So only the owner of the cert, with the `server-private-key` can read and do this key exchange.
* The Key exchange establishes a TLS connection with a symmetric key.

### Some question I had?

Q: But an attacker can intercept and have the `server-cert`, won't this cause a problem?
A: No, as the `server-cert`, is not a secret, it is public information. Everyone can have it, there is no problem with it. But the response to this `server-cert` is encrypted with the `server-private-key`. This response can only be read by the actual server who has the super secure `server-private-key`. So no attacker will be able to respond properly, even if he has the `server-cert`

Q: Can't an attacker just fabricate the `server-cert`?
A: No, because remember, this cert is signed by a super serious CA. This CA will never sign a cert from a scammy attacker.

## So what is mTLS?

So mTLS is the same as TLS, except both the client as well as the server present a certificate. The only difference between the client and the server in this case is:

* The client is the initiator of the request.
* The serve is the reciever of the request.
