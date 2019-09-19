Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCEFC3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 23:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B4F921907
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 23:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390172AbfISXMy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 19:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389806AbfISXMy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 19:12:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAE5A207FC;
        Thu, 19 Sep 2019 23:12:53 +0000 (UTC)
Date:   Thu, 19 Sep 2019 19:12:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io
Subject: Re: [PATCH v2 3/3] kernel-shark: Add quotation marks parsing
 example/test
Message-ID: <20190919191252.013a5e58@gandalf.local.home>
In-Reply-To: <20190918142319.11821-4-y.karadz@gmail.com>
References: <20190918142319.11821-1-y.karadz@gmail.com>
        <20190918142319.11821-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 18 Sep 2019 17:23:19 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The example implements a small GUI that executes shell commands.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

The testing on this seems to do what I think it should do.

I did modify it with this change, to get rid of the "Unknown error"
message on success. Care to send a v3?

-- Steve

diff --git a/kernel-shark/examples/cmd_split.cpp b/kernel-shark/examples/cmd_split.cpp
index ac688442..b8cc1b59 100644
--- a/kernel-shark/examples/cmd_split.cpp
+++ b/kernel-shark/examples/cmd_split.cpp
@@ -39,9 +39,10 @@ int main(int argc, char **argv)
 			proc.start();
 			proc.waitForFinished();
 
-			cout << proc.errorString().toStdString()
-			     << endl
-			     << proc.readAllStandardError().toStdString()
+			if (proc.exitCode())
+				cout << proc.errorString().toStdString() << endl;
+
+			cout << proc.readAllStandardError().toStdString()
 			     << endl
 			     << proc.readAllStandardOutput().toStdString()
 			     << endl;

