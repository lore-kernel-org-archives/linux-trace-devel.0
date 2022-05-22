Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1542EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 May 2022 00:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbiEVAjk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 21 May 2022 20:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiEVAjj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 21 May 2022 20:39:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB6646652
        for <linux-trace-devel@vger.kernel.org>; Sat, 21 May 2022 17:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699E660EF6
        for <linux-trace-devel@vger.kernel.org>; Sun, 22 May 2022 00:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5DBC34117;
        Sun, 22 May 2022 00:39:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nsZdA-000p8m-Pz;
        Sat, 21 May 2022 20:39:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] trace-cmd kvm timesync: Use stat() in kvm_scaling_check_vm_cpu()
Date:   Sat, 21 May 2022 20:39:32 -0400
Message-Id: <20220522003935.196466-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220522003935.196466-1-rostedt@goodmis.org>
References: <20220522003935.196466-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

kvm_scaling_check_vm_cpu() uses read_ll_from_file() to determine if the
kvm scaling and fraction files exist. The read_ll_from_file() does not
return if the contents of the files are legit or not. No need to read
them in this file. Just use stat().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync-kvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index 12a22d4c4d6a..a645fa2cc70b 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -75,22 +75,22 @@ static int read_ll_from_file(char *file, long long *res)
 
 static bool kvm_scaling_check_vm_cpu(char *vname, char *cpu)
 {
-	long long scaling, frac;
 	bool has_scaling = false;
 	bool has_frac = false;
+	struct stat st;
 	char *path;
 	int ret;
 
 	if (asprintf(&path, "%s/%s/%s", vname, cpu, KVM_DEBUG_SCALING_FILE) < 0)
 		return false;
-	ret = read_ll_from_file(path, &scaling);
+	ret = stat(path, &st);
 	free(path);
 	if (!ret)
 		has_scaling = true;
 
 	if (asprintf(&path, "%s/%s/%s", vname, cpu, KVM_DEBUG_FRACTION_FILE) < 0)
 		return false;
-	ret = read_ll_from_file(path, &frac);
+	ret = stat(path, &st);
 	free(path);
 	if (!ret)
 		has_frac = true;
-- 
2.35.1

