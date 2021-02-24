Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16593C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 19:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B469064EBA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 19:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhBXTbO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 14:31:14 -0500
Received: from esa6.hc324-48.eu.iphmx.com ([207.54.71.69]:13443 "EHLO
        esa6.hc324-48.eu.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230121AbhBXTbN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 14:31:13 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2021 14:31:12 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=bmw.de; i=@bmw.de; q=dns/txt; s=mailing1;
  t=1614195072; x=1645731072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=c/A4fwqoXdao7KmfqJnGNV97x/TNOYqSRt1ULVjd3gM=;
  b=LdLTHRGj6tkEKpbeRqi7TWmGp3xv71wWZc2uzMmRDF3M5SFZDwiiKqe6
   CybdnCkj5cablxCVPTf7Y7KQr1P54dR2Ckkh+2ksskZcX9JyJAzHvi/fn
   TIoWL458hF8RNyv13jhmuiTYYhdDuhjdvd2jLmq48U5yjOLaffUoewlwp
   E=;
Received: from esagw1.bmwgroup.com (HELO esagw1.muc) ([160.46.252.34]) by
 esa6.hc324-48.eu.iphmx.com with ESMTP/TLS; 24 Feb 2021 20:22:49 +0100
Received: from esabb4.muc ([160.50.100.33])  by esagw1.muc with ESMTP/TLS;
 24 Feb 2021 20:22:48 +0100
Received: from smucm10k.bmwgroup.net (HELO smucm10k.europe.bmw.corp) ([160.48.96.47])
 by esabb4.muc with ESMTP/TLS; 24 Feb 2021 20:22:48 +0100
Received: from smucm10m.europe.bmw.corp (160.48.96.49) by smucm10k.europe.bmw.corp
 (160.48.96.47) with Microsoft SMTP Server (TLS;
 Wed, 24 Feb 2021 20:22:48 +0100
Received: from smucm10m.europe.bmw.corp ([160.48.96.49]) by
 smucm10m.europe.bmw.corp ([160.48.96.49]) with mapi id 15.00.1497.010; Wed,
 24 Feb 2021 20:22:48 +0100
From:   <Viktor.Rosendahl@bmw.de>
To:     <rostedt@goodmis.org>
CC:     <linux-trace-devel@vger.kernel.org>
Subject: Re: Adding latency tracking to trace-cmd
Thread-Topic: Adding latency tracking to trace-cmd
Thread-Index: AQHXCs2xBMEUqLzwaEeKMZlRRHqkz6pnnn6A
Date:   Wed, 24 Feb 2021 19:22:48 +0000
Message-ID: <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
References: <20210224115408.1c76ee3f@gandalf.local.home>
In-Reply-To: <20210224115408.1c76ee3f@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA4B20534FE2AC49A9F97118C88307B7@bmwmail.corp>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

SGkgU3RldmUsDQoNCk9uIFdlZCwgMjAyMS0wMi0yNCBhdCAxMTo1NCAtMDUwMCwgU3RldmVuIFJv
c3RlZHQgd3JvdGU6DQo+IEhpIFZpa3RvciwNCj4gDQo+IFdoaWxlIGRvaW5nIHNvbWUgdGVzdHMg
dG8gdHJhY2UtY21kLCBJIGZvdW5kIHRoYXQgdGhlIHRyYWNlLWNtZCByZWNvcmQgd2FzDQo+IGJy
b2tlbiBmb3IgbGF0ZW5jeSB0cmFjZXJzLCBhbmQgaGFzIGJlZW4gZm9yIHNvbWUgdGltZS4gVGhh
dCdzIHByb2JhYmx5DQo+IGJlY2F1c2Ugbm9ib2R5IGhhcyBiZWVuIHVzaW5nIGl0IGZvciBzdWNo
Lg0KPiANCj4gVGhhdCBpcywgdHJhY2UtY21kIHJlY29yZCBpcyBtb3N0bHkgdXNlZCBmb3IgImZs
eXJlY29yZCIgd2hpY2ggaXMgdGhlDQo+IGNvbnN0YW50IHJlY29yZGluZyBvZiB0cmFjaW5nLiBC
dXQgaWYgdGhlIHVzZXIgcmVjb3JkcyBvbmUgb2YgdGhlIGxhdGVuY3kNCj4gdHJhY2VycyAocHJl
ZW1wdGlycXNvZmYsIHdha2V1cF9ydCwgZXRjKSwgdGhlbiBpdCBzd2l0Y2hlcyB0byAibGF0ZW5j
eSINCj4gbW9kZSBhbmQgb25seSB0YWtlcyBhIHNuYXBzaG90IGF0IHRoZSBlbmQgb2YgdGhlIHJl
Y29yZGluZy4gVGhpcyBpcyB3aGF0IEkNCj4gZm91bmQgdG8gYmUgYnJva2VuLCBiZWNhdXNlIGl0
IHJlc2V0IHRoZSB0cmFjaW5nIGJlZm9yZSB0YWtpbmcgdGhlDQo+IHNuYXBzaG90IGFuZCBsb3N0
IHdoYXRldmVyIGl0IHdhcyByZWNvcmRpbmcuIE5vYm9keSBzZWVtZWQgdG8gY29tcGxhaW4NCj4g
YWJvdXQgaXQsIHNvIEkgZ3Vlc3Mgbm9ib2R5IGNhcmVkLg0KPiANCg0KSSBoYXZlIHVzZWQgdHJh
Y2UtY21kIGJ1dCBJIGRpZCBub3Qga25vdyBhYm91dCB0aGlzIGZlYXR1cmUuIFNvbWVob3cgSSBo
YWQNCmFzc3VtZWQgdGhhdCB0cmFjZS1jbWQgd291bGQgbm90IGRlYWwgd2l0aCB0aG9zZSB0cmFj
ZXJzIHRoYXQgd29yayBpbiBvdmVyd3JpdGUNCm1vZGUuIA0KDQo+IFRoZSBmaXggaXMgc2ltcGxl
LCBhbmQgSSB3YXMgYWJvdXQgdG8gZG8gc28sIGJ1dCB0aGVuIEkgdGhvdWdodCBhYm91dCB5b3Vy
DQo+IGxhdGVuY3ktY29sbGVjdG9yIHRvb2wsIGFuZCB0aG91Z2h0IHRoYXQgc2hvdWxkIGJlIGV4
YWN0bHkgd2hhdCB0cmFjZS1jbWQNCj4gc2hvdWxkIGRvIGZvciBzdWNoIHRyYWNlcnMuIFRoYXQg
aXMsIGluc3RlYWQgb2YganVzdCB0YWtpbmcgYSBzbmFwc2hvdCBvZg0KPiB0aGUgbGF0ZW5jeSBh
dCB0aGUgZW5kIG9mIHRoZSByZWNvcmRpbmcgKHdoaWNoIGl0IHdhcyBzdXBwb3NlIHRvIGRvIG5v
dyksDQo+IGl0IHNob3VsZCBhY3QgbGlrZSB5b3VyIGxhdGVuY3ktY29sbGVjdG9yIHRvb2wsIGFu
ZCB0YWtlIHNuYXBzaG90cw0KPiBldmVyeSB0aW1lIHRoZXJlJ3MgYSBuZXcgbGF0ZW5jeS4NCj4g
DQo+IE15IHF1ZXN0aW9uIHRvIHlvdSBpcywgd291bGQgeW91IGxpa2UgdG8gd29yayBvbiBhZGRp
bmcgdGhhdCBmZWF0dXJlIHRvDQo+IHRyYWNlLWNtZD8NCg0KSSB3b3VsZCBiZSBpbnRlcmVzdGVk
IHRvIHdvcmsgb24gdGhlIGZlYXR1cmUgYnV0IEkgd291bGQgcHJvYmFibHkgbmVlZA0KcGVybWlz
c2lvbiBmcm9tIG15IGVtcGxveWVyLCBhbHNvIGluIGNhc2UgSSBkbyBpdCBhcyBhIHNwYXJlIHRp
bWUgcHJvamVjdC4NCg0KRm9yIHRoaXMgcmVhc29uLCBJIHdpbGwgbmVlZCBzb21lIHRpbWUgY29t
ZSB0byBhIGRlY2lzaW9uLiBJIHdpbGwgZ2V0IGJhY2sgdG8NCnlvdSB3aGVuIEkga25vdyB0aGUg
YW5zd2VyLg0KDQo+IA0KPiAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vdXRpbHMvdHJh
Y2UtY21kL3RyYWNlLWNtZC5naXQNCj4gDQo+ICh3aGljaCByZXF1aXJlcyB0aGUgbGlidHJhY2Vm
cyBhbmQgbGlidHJhY2V2ZW50IGxpYnJhcmllcykuDQo+IA0KPiBJJ20gdGhpbmtpbmcgaWYgc29t
ZW9uZSB3ZXJlIHRvIGRvOg0KPiANCj4gIHRyYWNlLWNtZCByZWNvcmQgLXAgd2FrZXVwX3J0IA0K
PiANCj4gSXQgd291bGQgdGhlbiBhY3QganVzdCBsaWtlIHRoZSBsYXRlbmN5LWNvbGxlY3RvciBh
bmQgcmVjb3JkIGV2ZXJ5IG5ldw0KPiBpbnN0YW5jZSBvZiBhIGxhdGVuY3kgaW50byB0aGUgdHJh
Y2UuZGF0IGZpbGUsIHdoZXJlOg0KPiANCj4gIHRyYWNlLWNtZCByZXBvcnQNCj4gDQo+IHdvdWxk
IHRoZW4gbmljZWx5IGZvcm1hdCB0aGF0IGRhdGEgZm9yIHRoZSB1c2VyLg0KPiANCj4gVGhvdWdo
dHM/DQoNCkl0IHNlZW1zIGxpa2UgdHJhY2UtY21kIGlzIG1vc3RseSBHUEwtMi4wLiBUaGUgbGF0
ZW5jeS1jb2xsZWN0b3IgaXMgYWxzbyBHUEwtDQoyLjAsIHNvIEkgZ3Vlc3MgdGhhdCBpdCB3b3Vs
ZCBiZSBwb3NzaWJsZSB0byB0YWtlIHNuaXBwZXRzIG9mIGNvZGUgYW5kDQppbnNwaXJhdGlvbiBm
cm9tIGl0Lg0KDQpXb3VsZCB5b3UgYWxsb3cgdGhlIGhhY2tpc2ggcmFuZG9tIGFsZ29yaXRobSB0
byBiZSB1c2VkIGluIHRyYWNlLWNtZD8NCkkgbWVhbiB0aGUgIi0tcmFuZG9tIiBvcHRpb24gaW4g
bGF0ZW5jeS1jb2xsZWN0b3IuDQoNCmJlc3QgcmVnYXJkcywNCg0KVmlrdG9yDQoNCj4gDQo+IC0t
IFN0ZXZlDQo=
