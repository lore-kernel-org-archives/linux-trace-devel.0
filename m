Return-Path: <SRS0=lb7a=W5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6ABC3A59E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Sep 2019 11:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2253216C8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Sep 2019 11:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbfIBLXV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 07:23:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:10233 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729844AbfIBLXV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 07:23:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Sep 2019 04:23:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,459,1559545200"; 
   d="txt'?scan'208";a="382771365"
Received: from irsmsx107.ger.corp.intel.com ([163.33.3.99])
  by fmsmga006.fm.intel.com with ESMTP; 02 Sep 2019 04:23:19 -0700
Received: from irsmsx110.ger.corp.intel.com ([169.254.15.10]) by
 IRSMSX107.ger.corp.intel.com ([169.254.10.55]) with mapi id 14.03.0439.000;
 Mon, 2 Sep 2019 12:23:19 +0100
From:   "Uhanov, Kirill" <kirill.uhanov@intel.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: RE: [PATCH ]trace-recorder.c
Thread-Topic: [PATCH ]trace-recorder.c
Thread-Index: AdVhgKEnIuYKyx0eQJmS4chAO322xw==
Date:   Mon, 2 Sep 2019 11:23:18 +0000
Message-ID: <E9875C329132824C9E8D827BD6069E125C64C39A@irsmsx110.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWY3YzAzZDItNzIyZC00NDkxLWJkNGYtZDE3NTM3NjIxNDE2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVVhRMk1sa09ROUZzd3dSUXMzS2tid284MVVyV2FKMHhEbUxXdkE0VnBaK29Ia3d0S3ZHOFwvcTZSeHdieDNIVFoifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [163.33.239.180]
Content-Type: multipart/mixed;
        boundary="_003_E9875C329132824C9E8D827BD6069E125C64C39Airsmsx110gercor_"
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

--_003_E9875C329132824C9E8D827BD6069E125C64C39Airsmsx110gercor_
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64

SG9wZSBpcyBvayBpZiBJIGp1c3QgYWRkIHNpZ24tb2ZmIGZpbGUuDQpUaGFua3MsIEtpcmlsbA0K
DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogU3RldmVuIFJvc3RlZHQgPHJvc3Rl
ZHRAZ29vZG1pcy5vcmc+IA0KU2VudDogU2F0dXJkYXksIEF1Z3VzdCAzMSwgMjAxOSAxMjo0NSBB
TQ0KVG86IFVoYW5vdiwgS2lyaWxsIDxraXJpbGwudWhhbm92QGludGVsLmNvbT4NCkNjOiBsaW51
eC10cmFjZS1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiB0cmFjZS1yZWNvcmRl
ci5jIHBhdGNoDQoNCg0KSGkgS2lyaWxsLA0KDQpXZSB0cnkgdG8gZm9sbG93IHRoZSBMaW51eCBr
ZXJuZWwgbWV0aG9kIG9mIHNlbmRpbmcgcGF0Y2hlcy4gWW91IGNhbiByZWFkIHRoYXQgaGVyZToN
Cg0KICBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL3Y0LjE3L3Byb2Nlc3Mvc3VibWl0
dGluZy1wYXRjaGVzLmh0bWwNCg0KSWYgeW91IG9ubHkgd2FudCB0byBhZGQgdGhpcyBvbmUgZml4
IGFuZCBkbyBub3QgcGxhbiBvbiBzZW5kaW5nIG90aGVyIGZpeGVzICh0aHVzIHlvdSBtYXkgbm90
IGNhcmUgYWJvdXQgdGhlIGZvcm1hbCBwcm9jZXNzKSwgYXQgYSBtaW5pbXVtIHdlIG5lZWQgeW91
IHRvIGFkZCBhOg0KDQogIlNpZ25lZC1vZmYtYnk6IFlvdXIgTmFtZSA8eW91ci1lbWFpbD4iDQoN
ClRoaXMgaXMgZGVzY3JpYmVkIGluIHNlY3Rpb24gMTEgIlNpZ24geW91ciB3b3JrIC0gdGhlIERl
dmVsb3BlcuKAmXMgQ2VydGlmaWNhdGUgb2YgT3JpZ2luIiBvZiB0aGUgYWJvdmUgbGluay4NCg0K
VGhhbmtzIQ0KDQotLSBTdGV2ZQ0KDQoNCk9uIFRodSwgMTUgQXVnIDIwMTkgMTU6MTM6MjggKzAw
MDANCiJVaGFub3YsIEtpcmlsbCIgPGtpcmlsbC51aGFub3ZAaW50ZWwuY29tPiB3cm90ZToNCg0K
PiBIaSBBbGwuDQo+IA0KPiBMb29rcyBsaWtlIHNvbWUgdHlwbyBpbiBsaWIvdHJhY2UtY21kL3Ry
YWNlLXJlY29yZGVyLmMNCj4gDQo+IENvdWxkIHlvdSBhcHBseSBwYXRjaD8NCj4gDQo+IGRpZmYg
LS1naXQgYS9saWIvdHJhY2UtY21kL3RyYWNlLXJlY29yZGVyLmMgDQo+IGIvbGliL3RyYWNlLWNt
ZC90cmFjZS1yZWNvcmRlci5jDQo+IA0KPiBpbmRleCAwYmQwNjU3Li42NTBiMjU5IDEwMDY0NA0K
PiANCj4gLS0tIGEvbGliL3RyYWNlLWNtZC90cmFjZS1yZWNvcmRlci5jDQo+IA0KPiArKysgYi9s
aWIvdHJhY2UtY21kL3RyYWNlLXJlY29yZGVyLmMNCj4gDQo+IEBAIC0yNDQsNyArMjQ0LDcgQEAg
dHJhY2VjbWRfY3JlYXRlX2J1ZmZlcl9yZWNvcmRlcl9tYXhrYihjb25zdCBjaGFyIA0KPiAqZmls
ZSwgaW50IGNwdSwgdW5zaWduZWQgZmxhZ3MsDQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGdvdG8gb3V0Ow0KPiANCj4gICAgICAgICAgICAgICAgZmQyID0gb3BlbihmaWxlMiwg
T19SRFdSIHwgT19DUkVBVCB8IE9fVFJVTkMgfCANCj4gT19MQVJHRUZJTEUsIDA2NDQpOw0KPiAN
Cj4gLSAgICAgICAgICAgICBpZiAoZmQgPCAwKQ0KPiANCj4gKyAgICAgICAgICAgICBpZiAoZmQy
IDwgMCkNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnI7DQo+IA0K
PiAgICAgICAgICAgICAgICByZWNvcmRlciA9IHRyYWNlY21kX2NyZWF0ZV9idWZmZXJfcmVjb3Jk
ZXJfZmQyKGZkLCBmZDIsIA0KPiBjcHUsIGZsYWdzLCBidWZmZXIsIG1heGtiKTsNCj4gDQo+IFRo
YW5rcywgS2lyaWxsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBKb2ludCBTdG9jayBDb21wYW55IElu
dGVsIEEvTw0KPiBSZWdpc3RlcmVkIGxlZ2FsIGFkZHJlc3M6IEtyeWxhdHNreSBIaWxscyBCdXNp
bmVzcyBQYXJrLA0KPiAxNyBLcnlsYXRza2F5YSBTdHIuLCBCbGRnIDQsIE1vc2NvdyAxMjE2MTQs
IFJ1c3NpYW4gRmVkZXJhdGlvbg0KPiANCj4gVGhpcyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50
cyBtYXkgY29udGFpbiBjb25maWRlbnRpYWwgbWF0ZXJpYWwgZm9yIA0KPiB0aGUgc29sZSB1c2Ug
b2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gQW55IHJldmlldyBvciBkaXN0cmlidXRpb24g
DQo+IGJ5IG90aGVycyBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLiBJZiB5b3UgYXJlIG5vdCB0aGUg
aW50ZW5kZWQgDQo+IHJlY2lwaWVudCwgcGxlYXNlIGNvbnRhY3QgdGhlIHNlbmRlciBhbmQgZGVs
ZXRlIGFsbCBjb3BpZXMuDQoNCgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpKb2ludCBTdG9jayBDb21wYW55IEludGVs
IEEvTwpSZWdpc3RlcmVkIGxlZ2FsIGFkZHJlc3M6IEtyeWxhdHNreSBIaWxscyBCdXNpbmVzcyBQ
YXJrLAoxNyBLcnlsYXRza2F5YSBTdHIuLCBCbGRnIDQsIE1vc2NvdyAxMjE2MTQsClJ1c3NpYW4g
RmVkZXJhdGlvbgoKVGhpcyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBtYXkgY29udGFpbiBj
b25maWRlbnRpYWwgbWF0ZXJpYWwgZm9yCnRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVj
aXBpZW50KHMpLiBBbnkgcmV2aWV3IG9yIGRpc3RyaWJ1dGlvbgpieSBvdGhlcnMgaXMgc3RyaWN0
bHkgcHJvaGliaXRlZC4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkCnJlY2lwaWVudCwgcGxl
YXNlIGNvbnRhY3QgdGhlIHNlbmRlciBhbmQgZGVsZXRlIGFsbCBjb3BpZXMuCg==

--_003_E9875C329132824C9E8D827BD6069E125C64C39Airsmsx110gercor_
Content-Type: text/plain; name="sign-off.txt"
Content-Description: sign-off.txt
Content-Disposition: attachment; filename="sign-off.txt"; size=123;
	creation-date="Mon, 02 Sep 2019 11:22:03 GMT";
	modification-date="Mon, 02 Sep 2019 11:21:42 GMT"
Content-Transfer-Encoding: base64

dG9vbHMgbGliIHRyYWNlLWNtZDogRml4IHR5cG8gd2l0aCBmaWxlIGRlc2NyaXB0aW9uIGNvbmR0
aXRpb25zDQoNClNpZ25lZC1vZmYtYnk6IEtpcmlsbCBVaGFub3YgPGtpcmlsbC51aGFub3ZAaW50
ZWwuY29tPg0K

--_003_E9875C329132824C9E8D827BD6069E125C64C39Airsmsx110gercor_
Content-Type: application/octet-stream; name="kuhanov.patch"
Content-Description: kuhanov.patch
Content-Disposition: attachment; filename="kuhanov.patch"; size=496;
	creation-date="Mon, 02 Sep 2019 11:22:55 GMT";
	modification-date="Mon, 02 Sep 2019 11:22:55 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYi90cmFjZS1jbWQvdHJhY2UtcmVjb3JkZXIuYyBiL2xpYi90cmFjZS1j
bWQvdHJhY2UtcmVjb3JkZXIuYwppbmRleCAwYmQwNjU3Li42NTBiMjU5IDEwMDY0NAotLS0gYS9s
aWIvdHJhY2UtY21kL3RyYWNlLXJlY29yZGVyLmMKKysrIGIvbGliL3RyYWNlLWNtZC90cmFjZS1y
ZWNvcmRlci5jCkBAIC0yNDQsNyArMjQ0LDcgQEAgdHJhY2VjbWRfY3JlYXRlX2J1ZmZlcl9yZWNv
cmRlcl9tYXhrYihjb25zdCBjaGFyICpmaWxlLCBpbnQgY3B1LCB1bnNpZ25lZCBmbGFncywKIAkJ
Z290byBvdXQ7CiAKIAlmZDIgPSBvcGVuKGZpbGUyLCBPX1JEV1IgfCBPX0NSRUFUIHwgT19UUlVO
QyB8IE9fTEFSR0VGSUxFLCAwNjQ0KTsKLQlpZiAoZmQgPCAwKQorCWlmIChmZDIgPCAwKQogCQln
b3RvIGVycjsKIAogCXJlY29yZGVyID0gdHJhY2VjbWRfY3JlYXRlX2J1ZmZlcl9yZWNvcmRlcl9m
ZDIoZmQsIGZkMiwgY3B1LCBmbGFncywgYnVmZmVyLCBtYXhrYik7Cg==

--_003_E9875C329132824C9E8D827BD6069E125C64C39Airsmsx110gercor_--

