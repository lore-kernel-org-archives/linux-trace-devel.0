Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F05E1A3BCB
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Oct 2024 12:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728909110; cv=none; b=lNfuEH9WxykUQYOaIDtk+y/pBhHoc3szfX09dB+zvzoARzYlWUd7dloEEfxEGtXy1E1qjDJ6PP+LQsa0nyRgO+uNf1io8ykiANSdimZa2WEV2/+QoGyfDeuGpkZUmfsaW8Uc+Z/sdE9gbVJOPiX/ElTVn2+fGRA3R3xfgZEePko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728909110; c=relaxed/simple;
	bh=sl/4oEy751i4WZZ6sI0qTlwQwhqnNo2SIYWkS8b0ujk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ND/xUYlOtmr1VarkcLfJb+tUSlz5WtY/eIsDIhbD7rYbpu0qFiSziVlTH8RhHkVghhTkFyVBTA+qvzd6OqnMyi12IuTfLknMJ/hOIcygnRcy1rG2Um4yJDtGu4ZiCqxNB+dx52Jc/PMC1JcwjHPQVrnR/ztqt2r4SI6JD7PeAHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CF221688;
	Mon, 14 Oct 2024 05:32:18 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 004743F71E;
	Mon, 14 Oct 2024 05:31:47 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2 3/4] trace-cmd reset: Update man page for -k option
Date: Mon, 14 Oct 2024 13:31:35 +0100
Message-Id: <20241014123136.3890807-4-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241014123136.3890807-1-metin.kaya@arm.com>
References: <20241014123136.3890807-1-metin.kaya@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Talk about the new -k command line parameter of "trace-cmd reset" in the
trace-cmd man page.

While we are here, fix typo 'immediatly'.

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 Documentation/trace-cmd/trace-cmd-reset.1.txt | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-reset.1.txt b/Documentation/trace-cmd/trace-cmd-reset.1.txt
index eee86751..026232ac 100644
--- a/Documentation/trace-cmd/trace-cmd-reset.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-reset.1.txt
@@ -60,7 +60,7 @@ significant. See EXAMPLES.
 *-d*::
     This option deletes the instance buffer(s) specified by the most recently
     preceding *-B* or *-a* option. Because the top-level instance buffer
-    cannot be deleted, it is invalid to use this immediatly following *-t* or
+    cannot be deleted, it is invalid to use this immediately following *-t* or
     prior to any *-B* or *-a* option on the command line.
 
 *-t*::
@@ -68,6 +68,12 @@ significant. See EXAMPLES.
     this is the same as the default. But if *-B* or *-a* is used, this is
     required if the top level instance buffer should also be reset.
 
+*-k* 'dynevent-name'::
+    This option allows preserving specified dynamic event during reset. Valid
+    parameters are *kprobe*, *kretprobe*, *uprobe*, *uretprobe*, *eprobe*,
+    *synth* and *all* (for keeping all dynamic events). This may be used
+    multiple times to specify different dynamic event types.
+
 EXAMPLES
 --------
 
@@ -94,6 +100,10 @@ instance buffers exist, they will be unaffected:
 
     trace-cmd reset -b 1024
 
+Prevent *kprobes* and *kretprobes* from being destroyed during reset:
+
+    trace-cmd reset -k kprobe -k kretprobe
+
 
 SEE ALSO
 --------
-- 
2.34.1

