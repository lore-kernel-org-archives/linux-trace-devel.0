Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBC9C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 13:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354039AbiDONkY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 09:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354102AbiDONkI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 09:40:08 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B1502BD2E7
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 06:36:59 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-fkvsvyNDMsSnVF3WO25dFQ-1; Fri, 15 Apr 2022 09:36:55 -0400
X-MC-Unique: fkvsvyNDMsSnVF3WO25dFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54191296A62C;
        Fri, 15 Apr 2022 13:36:55 +0000 (UTC)
Received: from f34.bristot.me (unknown [10.22.8.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F185A9E89;
        Fri, 15 Apr 2022 13:36:40 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, lkml@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        John Kacur <jkacur@redhat.com>,
        Daniel Bristot de Oliveria <bristot@redhat.com>
Subject: [PATCH 2/3] rtla: Don't overwrite existing directory mode
Date:   Fri, 15 Apr 2022 15:36:29 +0200
Message-Id: <a5d0f4f07cf0734307f0b6cc497bb4afc97e049f.1650029027.git.bristot@kernel.org>
In-Reply-To: <cover.1650029027.git.bristot@kernel.org>
References: <cover.1650029027.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; x-default=true
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

RnJvbTogSm9obiBLYWN1ciA8amthY3VyQHJlZGhhdC5jb20+DQoNClRoZSBtb2RlIG9uIC91c3Iv
YmluIGlzIG9mdGVuIDU1NSB0aGVzZSBkYXlzLA0KYnV0IG1ha2UgaW5zdGFsbCBvbiBydGxhIG92
ZXJ3cml0ZXMgdGhpcyB3aXRoIDc1NQ0KDQpGaXggdGhpcyBieSBwcmVzZXJ2aW5nIHRoZSBjdXJy
ZW50IGRpcmVjdG9yeSBpZiBpdCBleGlzdHMuDQoNCkxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL3IvMjAyMjA0MDIwNDM5MzkuNjk2Mi0xLWprYWN1ckByZWRoYXQuY29tDQoNCkNjOiBTdGV2
ZW4gUm9zdGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCkNjOiBEYW5pZWwgQnJpc3RvdCBkZSBP
bGl2ZXJpYSA8YnJpc3RvdEByZWRoYXQuY29tPg0KRml4ZXM6IDc5Y2U4ZjQzYWM1YSAoInJ0bGE6
IFJlYWwtVGltZSBMaW51eCBBbmFseXNpcyB0b29sIikNCkFja2VkLWJ5OiBEYW5pZWwgQnJpc3Rv
dCBkZSBPbGl2ZWlyYSA8YnJpc3RvdEBrZXJuZWwub3JnPg0KU2lnbmVkLW9mZi1ieTogSm9obiBL
YWN1ciA8amthY3VyQHJlZGhhdC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgQnJpc3RvdCBk
ZSBPbGl2ZWlyYSA8YnJpc3RvdEBrZXJuZWwub3JnPg0KLS0tDQogdG9vbHMvdHJhY2luZy9ydGxh
L01ha2VmaWxlIHwgMyArKy0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS90b29scy90cmFjaW5nL3J0bGEvTWFrZWZpbGUgYi90
b29scy90cmFjaW5nL3J0bGEvTWFrZWZpbGUNCmluZGV4IDVhMWVkYTYxNzk5Mi4uNGI2MzVkNGRl
MDE4IDEwMDY0NA0KLS0tIGEvdG9vbHMvdHJhY2luZy9ydGxhL01ha2VmaWxlDQorKysgYi90b29s
cy90cmFjaW5nL3J0bGEvTWFrZWZpbGUNCkBAIC0yMyw2ICsyMyw3IEBAICQoY2FsbCBhbGxvdy1v
dmVycmlkZSxMRF9TT19DT05GX1BBVEgsL2V0Yy9sZC5zby5jb25mLmQvKQ0KICQoY2FsbCBhbGxv
dy1vdmVycmlkZSxMRENPTkZJRyxsZGNvbmZpZykNCiANCiBJTlNUQUxMCT0JaW5zdGFsbA0KK01L
RElSCT0JbWtkaXINCiBGT1BUUwk6PQktZmx0bz1hdXRvIC1mZmF0LWx0by1vYmplY3RzIC1mZXhj
ZXB0aW9ucyAtZnN0YWNrLXByb3RlY3Rvci1zdHJvbmcgXA0KIAkJLWZhc3luY2hyb25vdXMtdW53
aW5kLXRhYmxlcyAtZnN0YWNrLWNsYXNoLXByb3RlY3Rpb24NCiBXT1BUUwk6PSAJLVdhbGwgLVdl
cnJvcj1mb3JtYXQtc2VjdXJpdHkgLVdwLC1EX0ZPUlRJRllfU09VUkNFPTIgLVdwLC1EX0dMSUJD
WFhfQVNTRVJUSU9OUyAtV25vLW1heWJlLXVuaW5pdGlhbGl6ZWQNCkBAIC02OCw3ICs2OSw3IEBA
IHN0YXRpYzogJChPQkopDQogDQogLlBIT05ZOiBpbnN0YWxsDQogaW5zdGFsbDogZG9jX2luc3Rh
bGwNCi0JJChJTlNUQUxMKSAtZCAtbSA3NTUgJChERVNURElSKSQoQklORElSKQ0KKwkkKE1LRElS
KSAtcCAkKERFU1RESVIpJChCSU5ESVIpDQogCSQoSU5TVEFMTCkgcnRsYSAtbSA3NTUgJChERVNU
RElSKSQoQklORElSKQ0KIAkkKFNUUklQKSAkKERFU1RESVIpJChCSU5ESVIpL3J0bGENCiAJQHRl
c3QgISAtZiAkKERFU1RESVIpJChCSU5ESVIpL29zbm9pc2UgfHwgcm0gJChERVNURElSKSQoQklO
RElSKS9vc25vaXNlDQotLSANCjIuMzUuMQ0K

