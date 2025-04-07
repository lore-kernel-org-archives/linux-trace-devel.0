Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4B5823DE
	for <linux-trace-devel@vger.kernel.org>; Mon,  7 Apr 2025 22:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744063291; cv=none; b=NixA5jE0t5otB8DQpD7LBvdFRxdUOAZcShshwdvzejaz0Q39/jtVVYag4bn+27PpCSm7xIHRfyPhCabRv3MkcoCX0a2o56uIW3vHeF9M+tiYVUsxtkir1O+7lz03HI0Ox074hJ35QZZI7wGm6jH27V8Pi+LqKm06oYF0QErGG9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744063291; c=relaxed/simple;
	bh=TGi30Qt9sVSZf6kAWfDWwpRzX40VCWSRh29Z52sJB40=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=Eq9H5dBFpW4ggtU4InIQpKPNuGuuNpxXMz5WLt42uScfSLNfozB/POu3hv3TmS2WxVbHzR9P1N0uyrJ67HRYCEbfmYgLgbwzw/+dq3nW+Ra2Q0js3G+/NkJFFkHyFAqO10utuJSWpUjCcN9VlnKvNRWgO23KYp/nXwNMFkmFlhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC31AC4CEDD
	for <linux-trace-devel@vger.kernel.org>; Mon,  7 Apr 2025 22:01:30 +0000 (UTC)
Date: Mon, 7 Apr 2025 18:02:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add trace-cmd set to bash completion (like
 start)
Message-ID: <20250407180246.19f53830@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The trace-cmd set command is the same as trace-cmd start except that it
doesn't reset tracefs before starting the tracing. Nor does it enable
tracing. But it does pretty much all the other commands.

Have trace-cmd set have the same tab completions as trace-cmd start.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index 01a75578..d7816bcf 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -348,7 +348,7 @@ _trace_cmd_complete()
 	    __trace_cmd_extract_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
 	    ;;
-	record|stream|start|profile)
+	record|stream|start|set|profile)
 	    __trace_cmd_record_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
 	    ;;
-- 
2.47.2

