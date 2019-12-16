Return-Path: <SRS0=pI6O=2G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E95C43603
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 15:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0462A20717
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 15:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfLPPrQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 10:47:16 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:59677 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728355AbfLPPrQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 10:47:16 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-84-fwAR4vKpNAquMMTtnFo5Ew-1; Mon, 16 Dec 2019 15:47:13 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 16 Dec 2019 15:47:12 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 16 Dec 2019 15:47:12 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tom Zanussi' <zanussi@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven Schnelle <svens@stackframe.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: ftrace histogram sorting broken on BE architecures
Thread-Topic: ftrace histogram sorting broken on BE architecures
Thread-Index: AQHVsSDKonZphcun20Oca4kHPqdeCKe87LwA
Date:   Mon, 16 Dec 2019 15:47:12 +0000
Message-ID: <4805b40c3e1547f8a26eeac6932f6499@AcuMS.aculab.com>
References: <20191211123316.GD12147@stackframe.org>
         <20191211103557.7bed6928@gandalf.local.home>
         <20191211110959.2baeb70f@gandalf.local.home>
 <1576178241.3309.2.camel@kernel.org>
In-Reply-To: <1576178241.3309.2.camel@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: fwAR4vKpNAquMMTtnFo5Ew-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PiBGcm9tOiBUb20gWmFudXNzaQ0KPiBTZW50OiAxMiBEZWNlbWJlciAyMDE5IDE5OjE3DQo+IE9u
IFdlZCwgMjAxOS0xMi0xMSBhdCAxMTowOSAtMDUwMCwgU3RldmVuIFJvc3RlZHQgd3JvdGU6DQo+
ID4gT24gV2VkLCAxMSBEZWMgMjAxOSAxMDozNTo1NyAtMDUwMA0KPiA+IFN0ZXZlbiBSb3N0ZWR0
IDxyb3N0ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToNCj4gPg0KPiA+ID4gPiBBbnkgdGhvdWdodHMg
b24gaG93IHRvIGZpeCB0aGlzPyBJJ20gbm90IHN1cmUgd2hldGhlciBpIGZ1bGx5DQo+ID4gPiA+
IHVuZGVyc3RhbmQgdGhlDQo+ID4gPiA+IGZ0cmFjZSBtYXBzLi4uIDstKQ0KPiA+ID4NCj4gPiA+
IFlvdXIgYW5hbHlzaXMgbWFrZXMgc2Vuc2UuIEknbGwgdGFrZSBhIGRlZXBlciBsb29rIGF0IGl0
Lg0KPiA+DQo+ID4gU3ZlbiwNCj4gPg0KPiA+IERvZXMgdGhpcyBwYXRjaCBmaXggaXQgZm9yIHlv
dT8NCj4gPg0KPiA+IFRvbSwNCj4gPg0KPiA+IENvcnJlY3QgbWUgaWYgSSdtIHdyb25nLCBmcm9t
IHdoYXQgSSBjYW4gdGVsbCwgYWxsIHN1bXMgYW5kIGtleXMgYXJlDQo+ID4gdTY0IHVubGVzcyB0
aGV5IGFyZSBhIHN0cmluZy4gVGh1cywgSSBiZWxpZXZlIHRoaXMgcGF0Y2ggc2hvdWxkIG5vdA0K
PiA+IGhhdmUgYW55IGlzc3Vlcy4NCi4uLg0KPiA+IC0tLSBhL2tlcm5lbC90cmFjZS90cmFjaW5n
X21hcC5jDQo+ID4gKysrIGIva2VybmVsL3RyYWNlL3RyYWNpbmdfbWFwLmMNCj4gPiBAQCAtMTQ4
LDggKzE0OCw4IEBAIHN0YXRpYyBpbnQgdHJhY2luZ19tYXBfY21wX2F0b21pYzY0KHZvaWQgKnZh
bF9hLA0KPiA+IHZvaWQgKnZhbF9iKQ0KPiA+ICAjZGVmaW5lIERFRklORV9UUkFDSU5HX01BUF9D
TVBfRk4odHlwZSkgCVwNCj4gPiAgc3RhdGljIGludCB0cmFjaW5nX21hcF9jbXBfIyN0eXBlKHZv
aWQgKnZhbF9hLCB2b2lkICp2YWxfYikgXA0KPiA+ICB7IFwNCj4gPiAtCXR5cGUgYSA9ICoodHlw
ZSAqKXZhbF9hOyBcDQo+ID4gLQl0eXBlIGIgPSAqKHR5cGUgKil2YWxfYjsgXA0KPiA+ICsJdHlw
ZSBhID0gKHR5cGUpKCoodTY0ICopdmFsX2EpOyAJXA0KPiA+ICsJdHlwZSBiID0gKHR5cGUpKCoo
dTY0ICopdmFsX2IpOyAJXA0KPiA+IFwNCj4gPiAgCXJldHVybiAoYSA+IGIpID8gMSA6ICgoYSA8
IGIpID8gLTEgOiAwKTsgXA0KPiA+ICB9DQoNClRoYXQgbG9va3Mgc28gaG9ycmlkL3dyb25nIGl0
IGNhbid0IGJlIHJpZ2h0IG9uIGJvdGggQkUgYW5kIExFLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

