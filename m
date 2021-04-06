Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532A4C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 20:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2462A613D2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 20:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhDFUbk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:31:40 -0400
Received: from esa10.hc324-48.eu.iphmx.com ([207.54.69.29]:43829 "EHLO
        esa10.hc324-48.eu.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236359AbhDFUbj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 16:31:39 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 16:31:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=bmw.de; i=@bmw.de; q=dns/txt; s=mailing1;
  t=1617741091; x=1649277091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ChAIqdKYe7uwSrI5zj+HdElfKcKxGrRnOjCxlfquOFk=;
  b=N1NOQhNGQnykovBgHSlCbeP25rrvVteJUC0Aya74ISkJYMlKGGbOI+P3
   O8fwQHwhpeqvWk1i9pQSs7aI3CZTgaewz85vI53UaY6a9PlvskOZoc0kI
   P9OmT+jXtZJDSYGS0XddWpNWosCO00r9rqtF5qkKjB1Nd828+htZYPnV4
   w=;
Received: from esagw5.bmwgroup.com (HELO esagw5.muc) ([160.46.252.46]) by
 esa10.hc324-48.eu.iphmx.com with ESMTP/TLS; 06 Apr 2021 22:24:20 +0200
Received: from esabb1.muc ([160.50.100.31])  by esagw5.muc with ESMTP/TLS;
 06 Apr 2021 22:24:20 +0200
Received: from smucm10j.bmwgroup.net (HELO smucm10j.europe.bmw.corp) ([160.48.96.46])
 by esabb1.muc with ESMTP/TLS; 06 Apr 2021 22:24:19 +0200
Received: from smucm10m.europe.bmw.corp (160.48.96.49) by smucm10j.europe.bmw.corp
 (160.48.96.46) with Microsoft SMTP Server (TLS;
 Tue, 6 Apr 2021 22:24:19 +0200
Received: from smucm10m.europe.bmw.corp ([160.48.96.49]) by
 smucm10m.europe.bmw.corp ([160.48.96.49]) with mapi id 15.00.1497.012; Tue, 6
 Apr 2021 22:24:19 +0200
From:   <Viktor.Rosendahl@bmw.de>
To:     <rostedt@goodmis.org>
CC:     <linux-trace-devel@vger.kernel.org>
Subject: Re: Adding latency tracking to trace-cmd
Thread-Topic: Adding latency tracking to trace-cmd
Thread-Index: AQHXCs2xBMEUqLzwaEeKMZlRRHqkz6pnnn6AgEBBkwCAACizAIAABb6A
Date:   Tue, 6 Apr 2021 20:24:19 +0000
Message-ID: <65f872664c4e15b1f37d9877f6fe914612a7de1b.camel@bmw.de>
References: <20210224115408.1c76ee3f@gandalf.local.home>
         <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
         <20210406133806.0f3ab414@gandalf.local.home>
         <c85bd8239b17619cac002c3d4d820ec0d46a2362.camel@bmw.de>
In-Reply-To: <c85bd8239b17619cac002c3d4d820ec0d46a2362.camel@bmw.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
Content-Type: text/plain; charset="utf-8"
Content-ID: <884361D6BC08C248865AB1D70CF875D7@bmwmail.corp>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

T24gVHVlLCAyMDIxLTA0LTA2IGF0IDIyOjAzICswMjAwLCBWaWt0b3IgUm9zZW5kYWhsIHdyb3Rl
Og0KPiANCg0KPiANCj4gVGhlIHVzZWZ1bG5lc3MgbGllcyBpbiB0aGUgY2FzZSB3aGVyZSB5b3Ug
aGF2ZSBsYXRlbmNpZXMgdGhhdCBzeXN0ZW1hdGljYWxseQ0KPiBvY2N1ciB2ZXJ5IGNsb3NlIHRv
IGVhY2ggb3RoZXIuDQo+IA0KDQpJIHNob3VsZCBoYXZlIGRyb3BwZWQgdGhlICJ2ZXJ5IiBmcm9t
IHRoZSBzdGF0ZW1lbnQgYWJvdmUuDQoNCj4gDQo+IA0KPiBBZG1pdHRlZGx5LCBJIGhhdmUgbmV2
ZXIgZGV0ZWN0ZWQgYW55IHJlYWwgd29ybGQgY2FzZSBsaWtlIHRoZSBvbmUgZGVzY3JpYmVkDQo+
IGFib3ZlIGluIHRoZSBrZXJuZWwgYnV0IEkgZG9uJ3QgdGhpbmsgdGhhdCBpdCdzIGNvbXBsZXRl
bHkgdW50aGlua2FibGUuIA0KPiANCg0KSSBmb3Jnb3QgdG8gbWVudGlvbiB0aGF0IHRoZSBrZXJu
ZWwgaGFzIGEgc3ludGhldGljIGV4YW1wbGUgb2YgdGhpcyBzaXR1YXRpb24gaW4NCnRoZSBwcmVl
bXB0aXJxX2RlbGF5X3Rlc3QgbW9kdWxlLCBpZiB5b3UgdXNlIHRoZSBidXJzdF9zaXplIHBhcmFt
ZXRlci4NCg0KSWYgeW91IHdhbnQgdG8gc2VlIGFsbCB0aGUgZnVuY3Rpb25zIHByZWVtcHRpcnF0
ZXN0X1swLTldIGluIHlvdXIgc3RhY2sgdHJhY2VzLA0KdGhlbiB5b3UgcHJvYmFibHkgbmVlZCB0
byB1c2UgdGhlIC0tcmFuZG9tIG9wdGlvbi4NCg0KVGhlbiBhZ2FpbiB0aGlzIGJ1cnN0IGZlYXR1
cmUgd2FzIGltcGxlbWVudGVkIGJ5IG1lIGluIG9yZGVyIHRvIHRlc3QgdGhlDQpsYXRlbmN5LWNv
bGxlY3Rvci4NCg0KYmVzdCByZWdhcmRzLA0KDQpWaWt0b3INCg==
