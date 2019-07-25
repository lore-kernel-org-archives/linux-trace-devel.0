Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE681C7618B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 12:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B042C217F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 12:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388101AbfGYMpR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 08:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387824AbfGYMpR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 08:45:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63580217F4;
        Thu, 25 Jul 2019 12:45:16 +0000 (UTC)
Date:   Thu, 25 Jul 2019 08:45:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel-shark: Execute kshark-record from same dir
 as kshark-su-record
Message-ID: <20190725084514.410f1cb1@gandalf.local.home>
In-Reply-To: <f9ac2e19-cc65-6496-5c42-9668337e6506@gmail.com>
References: <20190723225044.576298160@goodmis.org>
        <20190723225238.701263380@goodmis.org>
        <f9ac2e19-cc65-6496-5c42-9668337e6506@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Jul 2019 12:01:34 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> I just realized that there is one problem with the patch. With this 
> modification, you can use only the installed version of the script (so 
> you more or less depend on PATH).
> 
> This will work:
>   kshark-su-record
> 
> This will work as well:
>   /usr/local/bin/kshark-su-record
> 
> However this will not work:
>   kernel-shark/bin/kshark-su-record
> 
> because you are trying to start with pkexec an executable from your $HOME

What about this patch?

-- Steve

diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
index 8c9fbd02a351..152d0cdff3e7 100755
--- a/kernel-shark/bin/kshark-su-record
+++ b/kernel-shark/bin/kshark-su-record
@@ -6,4 +6,8 @@ then
 fi
 
 THIS_DIR=`dirname $0`
+if [ "${THIS_DIR#/}" == "${THIS_DIR}" ]
+then
+    THIS_DIR=`pwd`"/$THIS_DIR"
+fi
 pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
