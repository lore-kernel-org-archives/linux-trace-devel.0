Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483F7C41517
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D25A22BE8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 19:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfGYTrk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 15:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfGYTrk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 15:47:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB0FB229F9;
        Thu, 25 Jul 2019 19:47:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hqjiF-0002Ig-3S; Thu, 25 Jul 2019 15:47:39 -0400
Message-Id: <20190725194738.979632340@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 25 Jul 2019 15:45:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Revert adding environment variables to kshark-su-record
References: <20190725194537.884800321@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

This reverts:

  8eb0d753e ("kernel-shark: Execute kshark-record from same dir as kshark-su-record")
  b084eb5aa ("kernel-shark: Set the DISPLAY environment for pkexec kshark-record")

As the policykit (when installed correctly), should handle both the path to
the executable, as well as the DISPLAY and XAUTHORITY environment variables.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/bin/kshark-su-record | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
index c14f03da9684..70d781d84335 100755
--- a/kernel-shark/bin/kshark-su-record
+++ b/kernel-shark/bin/kshark-su-record
@@ -2,5 +2,4 @@
 
 xhost +si:localuser:root &>/dev/null
 
-THIS_DIR=`dirname $0`
-pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
+pkexec kshark-record -o ${PWD}/trace.dat
-- 
2.20.1


