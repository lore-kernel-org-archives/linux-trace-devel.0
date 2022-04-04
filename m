Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6D4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 15:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356239AbiDDPQS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 11:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345897AbiDDPQN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 11:16:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807F31BEAE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 08:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CFE8615F2
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49932C340EE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 15:14:16 +0000 (UTC)
Date:   Mon, 4 Apr 2022 11:14:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Make msg_lseek() header prototype match
 the function prototype
Message-ID: <20220404111414.426850bf@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

msg_lseek() is defined in the header as:

  off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);

Where as the function is defined as:

  off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off64_t offset, int whence)

That is, the header has "off_t offset" and the C code has "off64_t offset".

Make the two match, as it causes build issues on some systems.

Fixes: bea1bfd0b19f9 ("trace-cmd: Make msg_lseek() header prototype match the function prototype")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/trace-cmd-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index f9892fa77a8c..6ac341374941 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -91,7 +91,7 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 int out_write_emty_cpu_data(struct tracecmd_output *handle, int cpus);
-off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off64_t offset, int whence);
 unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 unsigned int get_meta_strings_size(struct tracecmd_input *handle);
 
-- 
2.35.1

