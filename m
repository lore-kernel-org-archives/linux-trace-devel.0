Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr770078.outbound.protection.outlook.com ([40.107.77.78]:22172
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbeK0VNX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 16:13:23 -0500
From: Slavomir Kaslev <kaslevs@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Fix record --date flag when sending tracing
 data to a listener
Date: Tue, 27 Nov 2018 10:15:55 +0000
Message-ID: <CAE0o1Ns+4UXU+UEgVT=sJvLujCOEPa78-UA7J_UVLTEK1gHoqQ@mail.gmail.com>
References: <20181114154328.14731-1-kaslevs@vmware.com>
 <20181126130530.63e8df2f@gandalf.local.home>
In-Reply-To: <20181126130530.63e8df2f@gandalf.local.home>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <58067A208E2F8E42919DBED7E3FE22BB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

T24gTW9uLCBOb3YgMjYsIDIwMTggYXQgODowNiBQTSBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4gd3JvdGU6DQo+DQo+IE9uIFdlZCwgMTQgTm92IDIwMTggMTc6NDM6MjggKzAy
MDANCj4ga2FzbGV2c0B2bXdhcmUuY29tIHdyb3RlOg0KPg0KPiA+IEZyb206IFNsYXZvbWlyIEth
c2xldiA8a2FzbGV2c0B2bXdhcmUuY29tPg0KPiA+DQo+ID4gQ3VycmVudGx5IHRoZSBgdHJhY2Ut
Y21kIHJlY29yZGAgLS1kYXRlIGlzIG5vdCB0YWtlbiBpbnRvIGFjY291bnQgd2hlbiB0cmFjaW5n
DQo+ID4gZGF0YSBpcyBzZW50IHRvIGEgcmVtb3RlIGhvc3Qgd2l0aCB0aGUgLU4gZmxhZy4NCj4g
Pg0KPiA+IFRoaXMgcGF0Y2ggZml4ZXMgdGhpcyBieSB0aGUgd3JpdGluZyBvdXRwdXQgYnVmZmVy
IG9wdGlvbnMgZnJvbSB0aGUgcmVjb3JkaW5nDQo+ID4gc2lkZSBpbnN0ZWFkIG9mIG9uIHRoZSBs
aXN0ZW5lciBzaWRlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2xhdm9taXIgS2FzbGV2IDxr
YXNsZXZzQHZtd2FyZS5jb20+DQo+ID4gLS0tDQo+ID4NCj4NCj4gSSBkb24ndCBzZWUgYW55dGhp
bmcgdG9vIHdyb25nIHdpdGggaXQsIGFjY2VwdCB0aGUgZm9sbG93aW5nIHRlc3QgYnJva2U6DQo+
DQo+ICAkIGdpdCBjaGVja291dCB0cmFjZS1jbWQtdjIuNg0KPiAgJCBtYWtlDQo+ICAkIHN1ZG8g
Y3AgdHJhY2UtY21kIC91c3IvbG9jYWwvYmluL3RyYWNlLWNtZC12Mi42DQo+ICAkIGdpdCBjaGVj
a291dCBvcmlnaW4vbWFzdGVyDQo+ICAkIHBhdGNoIC1wMSA8IHRoaXMucGF0Y2gNCj4gICQgbWFr
ZQ0KPiAgJCB0cmFjZS1jbWQtdjIuNiBsaXN0ZW4gLXAgMTIzNDUNCj4NCj4gSW4gYW5vdGhlciB0
ZXJtaW5hbDoNCj4NCj4gICQgc3VkbyB0cmFjZS1jbWQgcmVjb3JkIC1OIDEyNy4wLjAuMToxMjM0
NSAtZSBzY2hlZCBzbGVlcCAxDQo+IHRyYWNlLWNtZDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9y
eQ0KPiAgIENhbm5vdCBoYW5kbGUgdGhlIHByb3RvY29sDQo+DQo+DQo+IFJlbWVtYmVyLCB3ZSBu
ZWVkIHRvIHJlbWFpbiBiYWNrd2FyZCBjb21wYXRpYmxlLiBXZSBhbHNvIG5lZWQgdG8gdGVzdA0K
PiB0aGlzIGNvZGUgcnVubmluZyBhcyBhIGxpc3RlbmVyLCBhbmQgdGhlIHRyYWNlLWNtZC12Mi42
IChhbmQgZWFybGllcikNCj4gYXMgdGhlIHJlY29yZGVyLg0KDQpUaGlzIGlzIGEgZGVzaWduIGJ1
ZyAodGhlIGJlc3Qga2luZCksIG1ldGFkYXRhIHNob3VsZCByZWFsbHkgYmUgd3JpdHRlbiBmcm9t
IHRoZQ0KcmVjb3JkaW5nIHNpZGUgYW5kIG5vdCBmcm9tIHRoZSBsaXN0ZW5lci4gQSBiYWNrd2Fy
ZCBjb21wYXRpYmxlIGZpeCBzaG91bGQgaGF2ZQ0KdGhlIG5ld2VyIHJlY29yZGVyIGFuZCBsaXN0
ZW5lciBkZXRlY3QgdGhleSdyZSB0YWxraW5nIHRvIGFuIG9sZGVyIHZlcnNpb24gYW5kDQpmYWxs
YmFjayB0byBicm9rZW4gYmVoYXZpb3IuIFRoaXMgaW1wbGllcyBhIG5ldyBwcm90b2NvbCB2ZXJz
aW9uIG9yIGV4dGVuZGluZw0KTVNHX1RJTklUL01TR19SSU5JVCBzbyB0aGF0IHdlIGNhbiBpbmZl
ciB0aGUgYmVoYXZpb3Igb24gdGhlIG90aGVyIHNpZGUgYW5kDQpmYWxsYmFjayB0byBiZWluZyBi
cm9rZW4gd2hlbiBuZWNlc3NhcnkuDQoNCldoYXQgd291bGQgeW91IHN1Z2dlc3Q/DQoNCi0tDQpT
bGF2aQ0K
