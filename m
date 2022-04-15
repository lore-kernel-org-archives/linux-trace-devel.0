Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F63CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 13:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348694AbiDONkY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 09:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354063AbiDONkI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 09:40:08 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4A38BD2E3
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 06:36:58 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-bt7Ow-LuMkC68MCFb30qgA-1; Fri, 15 Apr 2022 09:36:56 -0400
X-MC-Unique: bt7Ow-LuMkC68MCFb30qgA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60897185A794;
        Fri, 15 Apr 2022 13:36:56 +0000 (UTC)
Received: from f34.bristot.me (unknown [10.22.8.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AE3F9E78;
        Fri, 15 Apr 2022 13:36:55 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, lkml@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/3] rtla: Minor grammar fix for rtla README
Date:   Fri, 15 Apr 2022 15:36:30 +0200
Message-Id: <d44df964e89e620fa5676c65333365778b15d42f.1650029027.git.bristot@kernel.org>
In-Reply-To: <cover.1650029027.git.bristot@kernel.org>
References: <cover.1650029027.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; x-default=true
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

RnJvbTogSm9obiBLYWN1ciA8amthY3VyQHJlZGhhdC5jb20+DQoNCi0gQ2hhbmdlIHRvICJUaGUg
cnRsYSBtZXRhLXRvb2wgaW5jbHVkZXMiDQotIFJlbW92ZSBhbiB1bm5lY2Vzc2FyeSAiQnV0LCAi
DQotIEFkanVzdCB0aGUgZm9ybWF0dGluZyBvZiB0aGUgcGFyYWdyYXBoIHJlc3VsdGluZyBmcm9t
IHRoZSBjaGFuZ2VzLg0KLSBTaW1wbGlmeSB0aGUgd29yZGluZyBmb3IgdGhlIGxpYnJhcmllcyBh
bmQgdG9vbHMuDQoNCkxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMjA0MDgxNjEw
MTIuMTA1NDQtMS1qa2FjdXJAcmVkaGF0LmNvbS8NCg0KQ2M6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0
ZWR0QGdvb2RtaXMub3JnPg0KQ2M6IERhbmllbCBCcmlzdG90IGRlIE9saXZlcmlhIDxicmlzdG90
QGtlcm5lbC5vcmc+DQpGaXhlczogNzljZThmNDNhYzVhICgicnRsYTogUmVhbC1UaW1lIExpbnV4
IEFuYWx5c2lzIHRvb2wiKQ0KQWNrZWQtYnk6IERhbmllbCBCcmlzdG90IGRlIE9saXZlaXJhIDxi
cmlzdG90QGtlcm5lbC5vcmc+DQpTaWduZWQtb2ZmLWJ5OiBKb2huIEthY3VyIDxqa2FjdXJAcmVk
aGF0LmNvbT4NClNpZ25lZC1vZmYtYnk6IERhbmllbCBCcmlzdG90IGRlIE9saXZlaXJhIDxicmlz
dG90QGtlcm5lbC5vcmc+DQotLS0NCiB0b29scy90cmFjaW5nL3J0bGEvUkVBRE1FLnR4dCB8IDEy
ICsrKysrLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDcgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS90b29scy90cmFjaW5nL3J0bGEvUkVBRE1FLnR4dCBiL3Rv
b2xzL3RyYWNpbmcvcnRsYS9SRUFETUUudHh0DQppbmRleCA2Yzg4NDQ2ZjdlNzQuLjBmYmFkMjY0
MGI4YyAxMDA2NDQNCi0tLSBhL3Rvb2xzL3RyYWNpbmcvcnRsYS9SRUFETUUudHh0DQorKysgYi90
b29scy90cmFjaW5nL3J0bGEvUkVBRE1FLnR4dA0KQEAgLTEsMTUgKzEsMTMgQEANCiBSVExBOiBS
ZWFsLVRpbWUgTGludXggQW5hbHlzaXMgdG9vbHMNCiANCi1UaGUgcnRsYSBpcyBhIG1ldGEtdG9v
bCB0aGF0IGluY2x1ZGVzIGEgc2V0IG9mIGNvbW1hbmRzIHRoYXQNCi1haW1zIHRvIGFuYWx5emUg
dGhlIHJlYWwtdGltZSBwcm9wZXJ0aWVzIG9mIExpbnV4LiBCdXQsIGluc3RlYWQgb2YNCi10ZXN0
aW5nIExpbnV4IGFzIGEgYmxhY2sgYm94LCBydGxhIGxldmVyYWdlcyBrZXJuZWwgdHJhY2luZw0K
LWNhcGFiaWxpdGllcyB0byBwcm92aWRlIHByZWNpc2UgaW5mb3JtYXRpb24gYWJvdXQgdGhlIHBy
b3BlcnRpZXMNCi1hbmQgcm9vdCBjYXVzZXMgb2YgdW5leHBlY3RlZCByZXN1bHRzLg0KK1RoZSBy
dGxhIG1ldGEtdG9vbCBpbmNsdWRlcyBhIHNldCBvZiBjb21tYW5kcyB0aGF0IGFpbXMgdG8gYW5h
bHl6ZQ0KK3RoZSByZWFsLXRpbWUgcHJvcGVydGllcyBvZiBMaW51eC4gSW5zdGVhZCBvZiB0ZXN0
aW5nIExpbnV4IGFzIGEgYmxhY2sgYm94LA0KK3J0bGEgbGV2ZXJhZ2VzIGtlcm5lbCB0cmFjaW5n
IGNhcGFiaWxpdGllcyB0byBwcm92aWRlIHByZWNpc2UgaW5mb3JtYXRpb24NCithYm91dCB0aGUg
cHJvcGVydGllcyBhbmQgcm9vdCBjYXVzZXMgb2YgdW5leHBlY3RlZCByZXN1bHRzLg0KIA0KIElu
c3RhbGxpbmcgUlRMQQ0KIA0KLVJUTEEgZGVwZW5kcyBvbiBzb21lIGxpYnJhcmllcyBhbmQgdG9v
bHMuIE1vcmUgcHJlY2lzZWx5LCBpdCBkZXBlbmRzIG9uIHRoZQ0KLWZvbGxvd2luZyBsaWJyYXJp
ZXM6DQorUlRMQSBkZXBlbmRzIG9uIHRoZSBmb2xsb3dpbmcgbGlicmFyaWVzIGFuZCB0b29sczoN
CiANCiAgLSBsaWJ0cmFjZWZzDQogIC0gbGlidHJhY2VldmVudA0KLS0gDQoyLjM1LjENCg==

