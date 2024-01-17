Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D43515B7
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jan 2024 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705457581; cv=none; b=D/+MfP9DaS1S5+hEYg2pepMgNE4k9invCqBZoyQoVyBPPPae11xMoZBukX3emfpevmY5omREtvocGB1fF4fJtPtjrH+QypsB6QQOI8QvSO647K4ifFiW3vvHH4VWQ6S+6MRVFJ2HV9Mbhge7siEqJw7czz4eRSwhW3trc84DK5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705457581; c=relaxed/simple;
	bh=nopaMMZmwsFcnNxKIbkrqktgr8BOC+SdMxXTaPYHS1o=;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding; b=WEb/vd3OFsdBCKbbZZWyKLNCFBHQrA8MiFmbxi17ycnKUUzJ1eJw0pwW/+vt/27y+3CtbanNkexn22lt23FzGhL5FoN+l9cOLD1Pz6f67H/i+trTHHl39A6JWR786dpyzWAM0s6pAwBA+8p2hZVUF/Qwf++vLKsMzH4FAGTt/Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07936C433F1
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jan 2024 02:13:00 +0000 (UTC)
Date: Tue, 16 Jan 2024 21:14:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd split: Do not fail if cmdlines are not present
Message-ID: <20240116211415.41b530e5@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the input file that is being split does not contain a 'cmdline'
section, do not fail. The section is optional.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index dae5b90d7da9..ce4ecf43de74 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5722,9 +5722,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 		if (end_state <= in_handle->file_state)
 			return 0;
 
-		ret = copy_command_lines(in_handle, out_handle);
-		if (ret < 0)
-			goto out;
+		/* Optional */
+		copy_command_lines(in_handle, out_handle);
 
 		/* fallthrough */
 	case TRACECMD_FILE_CPU_COUNT:
-- 
2.43.0

