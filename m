Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20537F7C2
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706117587; cv=none; b=LapPtrDSPPy6iA8h6BarTXCGfP5amnU0ZH/tvVVQm+XemFjCICYCf9ARCn68KGWJUIz3RJQh7e1j/UygRFTTPpBkkECvcIYz8eDIsyePvVLypT/EmZIiZxp8UfSn8r7aQc/8Ak7TnSHLHHM6YajqXkOFvTtvXYMXVe9JsHbPfj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706117587; c=relaxed/simple;
	bh=DZIoQRQO5YgA12AHp9P9aYiQlJ+/8Nrw6NcoiitbmiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=VXXCl/uLg4PrFwJh5R+7cbVyAe3EGK6LM9j+0F1DQ+TVIz+1IWdtHLkruPP6zTtTG8lK8MAzFGWbCbNbtgM8WVp/74jrvLNdaSCbyNwMP92VyLG4Aw2WKoUg2QnBB4TlZWTSwMTI1pBbwv/HZzr6iV2nKNg7eSvFDrOoSJOWivI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5878DC433F1;
	Wed, 24 Jan 2024 17:33:06 +0000 (UTC)
Date: Wed, 24 Jan 2024 12:34:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH] trace-cmd split: Initialize current in parse_file()
Message-ID: <20240124123439.3441eb6f@gandalf.local.home>
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

The code fix to correctly split start/end/time-window parameters removed
an initialization of "current" which can now fall out being uninitialized
and used for a later compare.

Found with valgrind that reported uninitialized variable in the loop condition:

	do {
		if (repeat)
			sprintf(output_file, "%s.%04d", output, c++);
		else
			strcpy(output_file, output);
			
		current = parse_file(handle, output_file, start_ns, end_ns,
				     percpu, cpu, count, type, &end_reached);

		if (!repeat)
			break;
		start_ns = 0;
	} while (!end_reached && (current && (!end_ns || current < end_ns)));

Link: https://lore.kernel.org/linux-trace-devel/20240124122832.4e0b33b7@gandalf.local.home/

Fixes: 1439b8f518 ("trace-cmd split: Correctly split with start/end/time-window parameters")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 0820a3bb0721..2c311b3d6be3 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -480,7 +480,7 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				     enum split_types type,
 				     bool *end_reached)
 {
-	unsigned long long current;
+	unsigned long long current = 0;
 	struct handle_list *handle_entry;
 	struct tracecmd_output *ohandle;
 	struct cpu_data *cpu_data;
-- 
2.43.0

