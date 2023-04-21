Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1EEDC7618E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Apr 2023 12:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjDUMOO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 08:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjDUMON (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 08:14:13 -0400
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBB95B93;
        Fri, 21 Apr 2023 05:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682079248;
        bh=8x5jCW5wPuP6DrOsCE5IjoZHeW34R552D86Pcdt3a8A=;
        h=From:To:Cc:Subject:Date;
        b=TznuPqiM402uVGBNP03hOty7y6S/T6AGx5RZpOpbg3++DcuQ5KVfXKRCs46/EmknE
         I6ptxt5QQhE1bh35JtY23MnnMvLqtbi0U+7iYm9NY2w+JFXxSdhRRmzVYt6Ri/ysIm
         /NSBSirEYzLAHdWKukSAQrSMqke3wzjo3SZoDYhQ=
Received: from localhost.localdomain ([39.156.73.13])
        by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
        id 32983668; Fri, 21 Apr 2023 20:12:41 +0800
X-QQ-mid: xmsmtpt1682079161thbx1k54o
Message-ID: <tencent_8042C05909979D2A1AAFA8A3028854065808@qq.com>
X-QQ-XMAILINFO: MZ7OTbK+3aE539Ge5iJjPCG265xatopn3pMZtG9SI1lUM/33IpvN7YGJT0PCyE
         TcD/x6XDYsiUx130hSZzjSd7d1N5KHtTCqheWcG7zzaCdnnU0kzSFf6SPosG0GSUMsYZaAeEYLbv
         /nw8S4AgwDDa6+0WdH+eU5Q/D5OwjmC0+MYf0TAZOgvc1L3LTThydoM5uzIn+/wa7tMyd3sRVa1w
         6NfLURRh04wBVIEDqgNINdnQDmoq3DNgb+EnBk3p/TVJQu7i4F+muBhzfUTC9tltk0dgYjgO6oz7
         kSO0lUH9Fy9QuN3b/PGSOj5Fph7Tsd6CJIKMekMQjvS9Vs9OugGxfOMZ0Tn6A4qrAEHr/IWKWV0Y
         FxtBrHJQmB6IoBXDssASsWUGJSYTvzo0zGbRWymjIypOvNga/knGdZcLo0v5ip8n9bguSuNHBVWY
         klJIGW+4URbMYwb55Za040XFFbEzftLMZa+4sTlz+aI3OMLMX+j3IjKTaBBnJfvJSaChHAPtSK6S
         678eSyGNlpN5S1PYMgcoYIzqxZirZug/p3g+jDqR89sTTlKYyEbzWRlb1AWg60KPURkNORL1tz/b
         FJWFGg7o84mBNXdyqRZLLJAbTGKMPw1EAZCY4n2536E1SsvqpH5ixMaEoQUD2KLyhoDvwcWyMJfo
         uGxsV0j45UmpTD+KCll6eEFN1AmiDJsO3DyIj1GmTlqmxvqvAFPJbQKa8ijra6ayi+SKpFkSYf5A
         3tjc/APUhSM0Lju18o1CP6YN8zK8U1wesB1H/0L9livX53gZVwRQK26p8Y2XoBtD2agZuwSqRlFw
         OQrVWfsLaFjJM4EQ2gG8f5GGmDpp+W5eRseeJtCIOgoQbHOwqk7PIVq7SIrnnIbA/fD/IXDd1Cwq
         ggwODOY1CS5bl1vssUbnNB9WYDgM//BKXPGkFFwNEcLY6Ly6WI7nuvzDCCn3OKIzTm2uQXfhvZ9i
         i5KC/EUMasmlym8WafJyVlmFNtbn68+jQ0o/p6LtUi20FiQKQwHry4gLVQljJo
From:   Rong Tao <rtoax@foxmail.com>
To:     bristot@kernel.org
Cc:     rongtao@cestc.cn, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-trace-devel@vger.kernel.org (open list:Real-time Linux Analysis
        (RTLA) tools)
Subject: [PATCH] tools/tracing/rtla: Add .gitignore
Date:   Fri, 21 Apr 2023 20:12:37 +0800
X-OQ-MSGID: <20230421121237.240390-1-rtoax@foxmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Rong Tao <rongtao@cestc.cn>

Ignore rtla binary.

Signed-off-by: Rong Tao <rongtao@cestc.cn>
---
 tools/tracing/rtla/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/tracing/rtla/.gitignore

diff --git a/tools/tracing/rtla/.gitignore b/tools/tracing/rtla/.gitignore
new file mode 100644
index 000000000000..e9df32419b2b
--- /dev/null
+++ b/tools/tracing/rtla/.gitignore
@@ -0,0 +1 @@
+/rtla
-- 
2.39.1

