Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0072.outbound.protection.outlook.com ([104.47.38.72]:57904
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726886AbeKHAJm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 19:09:42 -0500
From: Slavomir Kaslev <kaslevs@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] Add VM kernel tracing using VSOCK socket for transport
Date: Wed, 7 Nov 2018 14:39:00 +0000
Message-ID: <CAE0o1Nv6ahNtC86atRwOUR-xz33AWupnR2FqtBYWYWT5mhA6cw@mail.gmail.com>
References: <20181106145902.13301-1-kaslevs@vmware.com>
 <20181107091243.5c601baa@gandalf.local.home>
In-Reply-To: <20181107091243.5c601baa@gandalf.local.home>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <3085F2D3D4873D48A861CB5FC342F829@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

T24gV2VkLCBOb3YgNywgMjAxOCBhdCA0OjEzIFBNIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdv
b2RtaXMub3JnPiB3cm90ZToNCj4NCj4gT24gVHVlLCAgNiBOb3YgMjAxOCAxNjo1OTowMiArMDIw
MA0KPiBrYXNsZXZzQHZtd2FyZS5jb20gd3JvdGU6DQo+DQo+ID4gRnJvbTogU2xhdm9taXIgS2Fz
bGV2IDxrYXNsZXZzQHZtd2FyZS5jb20+DQo+ID4NCj4gPiBUbyB0ZXN0LCBzdGFydCBhIFZNIGFu
ZCBhc3NpZ24gaXQgYSB2YWxpZCAoPiAyKSB1bnVzZWQgQ0lEOg0KPiA+DQo+ID4gICAgIHlvdUBo
b3N0ICMgcWVtdS1zeXN0ZW0teDg2XzY0IFwNCj4gPiAgICAgICAgIC1uYW1lIGd1ZXN0MiAtLXV1
aWQgN2VkZmRmNGEtY2I5ZS0xMWU4LWIzOGEtMTczYjU4MzQyNDc2IFwNCj4gPiAgICAgICAgIC1t
IDQwOTYgLWJvb3QgZCAtZW5hYmxlLWt2bSAtc21wIDMgLW5ldCBuaWMgLW5ldCB1c2VyIC1oZGEg
JEhPTUUvdm0vZ3Vlc3QyLmltZyBcDQo+ID4gICAgICAgICAtZnNkZXYgbG9jYWwsaWQ9aG9zdCxw
YXRoPSRIT01FLHNlY3VyaXR5X21vZGVsPW1hcHBlZCBcDQo+ID4gICAgICAgICAtZGV2aWNlIHZp
cnRpby05cC1wY2ksZnNkZXY9aG9zdCxtb3VudF90YWc9aG9zdCBcDQo+ID4gICAgICAgICAtZGV2
aWNlIHZpcnRpby1zZXJpYWwtcGNpLGlkPXZpcnRpby1zZXJpYWwwLGJ1cz1wY2kuMCxhZGRyPTB4
NiBcDQo+ID4gICAgICAgICAtY2hhcmRldiBwaXBlLGlkPWNoYXJjaGFubmVsMSxwYXRoPS92YXIv
bGliL3Rlc3QvZmlmbzAgXA0KPiA+ICAgICAgICAgLWRldmljZSB2aXJ0c2VyaWFscG9ydCxidXM9
dmlydGlvLXNlcmlhbDAuMCxucj0zLGNoYXJkZXY9Y2hhcmNoYW5uZWwxLGlkPWNoYW5uZWwxLG5h
bWU9ZmlmbzAgXA0KPiA+ICAgICAgICAgLWRldmljZSB2aG9zdC12c29jay1wY2ksaWQ9dmhvc3Qt
dnNvY2stcGNpMCxndWVzdC1jaWQ9Mw0KPg0KPiBJdCB3b3VsZCBiZSBtb3JlIGhlbHBmdWwgdG8g
c3BlY2lmeSB3aGF0IHBhcmFtZXRlcnMgYXJlIG5lZWRlZCBhbmQgd2h5Lg0KPiBUaGUgYWJvdmUg
aXNuJ3QgdXNlZnVsIGZvciBtZSwgYXMgSSBydW4gbXkgZ3Vlc3RzIHdpdGggbGlidmlydCwgYW5k
IGNhbg0KPiBoYXJkIGNvZGUgaW4gZXh0cmEgcGFyYW1ldGVycy4gQnV0IGlmIEkgZG9uJ3Qga25v
dyB3aGF0IEkgbmVlZCB0byBoYXJkDQo+IGNvZGUgaW4sIEkgY2FuJ3Qgc2ltdWxhdGUgaXQuDQoN
Ck9ubHkgdGhlIGxhc3QgbGluZSBpcyBuZWNlc3NhcnkgZm9yIHRlc3Rpbmc6DQoNCiAgICAtZGV2
aWNlIHZob3N0LXZzb2NrLXBjaSxpZD12aG9zdC12c29jay1wY2kwLGd1ZXN0LWNpZD0zDQoNCndo
ZXJlICdndWVzdC1jaWQ9MycgY2FuIGJlIGFueSBudW1iZXIgPiAyIGFuZCBpcyB1bmlxdWUgYWNy
b3NzIFZNcy4NClNvcnJ5IGFib3V0IHRoZSBub2lzeSBjb21tYW5kIGluIHRoZSBjb21taXQgbWVz
c2FnZSwgSSBhbHJlYWR5IGZpeGVkDQppdCBmb3IgVjIgb2YgdGhpcyBwYXRjaCB3aGljaCBJJ2xs
IHNlbmQgYWZ0ZXIgYWxsIGZlZWRiYWNrIGlzDQphZGRyZXNzZWQuDQo=
