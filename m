Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D65A32
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jul 2024 01:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721353682; cv=none; b=h2axh6A8qDDSNCFQZYnIulj7A/hbbWZsdetoYONPYURAVw/6qJQUBCM4JLSiu7eXCDcQ3Lkno71RCzPUM/QT9lwDvaQfB9SdClHjcHESP9SJOWhsT+jaYDYYwypw3qbRNbznj2AhPiN27Lsu9ZSXifV0qSfw6F1UQrGYkV3URbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721353682; c=relaxed/simple;
	bh=6xzJxTWOvvNjxAZjapiKRHXU6zN8HAyK7INl3baD6k0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=OtX8b7GLqoI1b0Q8XoGH+iodUG+tgFf+PFVscO6gSLYvsz+7LPonCD366gv+VUUqlp2iWXNFrdM/YKKBxXp8mZrlmmPW0ZjNtvPvv6BF/xlDseGh6gy+cGeZdSN7OdIXRTiURxwRKUHGM1tVOuQ5Ohu60+nZasKf8xAibJaHKh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDC7C116B1;
	Fri, 19 Jul 2024 01:48:01 +0000 (UTC)
Date: Thu, 18 Jul 2024 21:48:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH] trace-cmd record: Do not remove instances with -v
Message-ID: <20240718214806.27dfb413@gandalf.local.home>
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

The -v option was extended to delete instances. But this does not make sense
with the 'record' command. It only makes sense with the 'set' command.
Make sure that the 'set' command is used when deleting an instance,
otherwise it can cause adverse effects on the record side.

Link: https://lore.kernel.org/all/20240605134054.2626953-34-jmarchan@redhat.com/

Fixes: 2a3c58e75 ("trace-cmd: Extend option "-v" to delete an ftrace instance")
Reported-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4e9ac598..1527be11 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6748,7 +6748,8 @@ static void parse_record_options(int argc,
 			ctx->instance = allocate_instance(optarg);
 			if (!ctx->instance)
 				die("Failed to create instance");
-			ctx->instance->delete = negative;
+			if (IS_CMDSET(ctx))
+				ctx->instance->delete = negative;
 			negative = 0;
 			if (ctx->instance->delete) {
 				ctx->instance->next = del_list;
-- 
2.43.0

