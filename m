Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292A02EAE6
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2024 08:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713169595; cv=none; b=P8+zCQq9kze8W9RiMUOtF+/L/tHT2NzJmEtJlrr55ykjylzq93xPXy/7jeIsohy1mPCTMeUTf7NPyAwJTg0BQuOMeEs5+OiOCblQ8GApSydkG7ZcIs/jKxKd8uNuf64FzZsfWE1yh86Rpk5h5YharqVt0h7y3tiWN9Jda4H9/lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713169595; c=relaxed/simple;
	bh=+1nIMw2cLF3uSlve7jKFHqdrmlwgIfUY+eSeggWuD5E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=mO3FR1yPv7fab24wtUCOk3RMOtpfO1K6eJyA2Ey99GXodWhcucTMqn62NWvS7/W5rUXw20GtsAcow5gxYfBFYuUTxdk0YQKjnp/CThgmxEvKa1oJqqxsOC9k/DDvEpF5p/cgPkkw7vUSBLBIU0JeXBgkfudW3oL7EtcV5bCCRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4604BC113CC;
	Mon, 15 Apr 2024 08:26:34 +0000 (UTC)
Date: Mon, 15 Apr 2024 04:26:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH] libtraceevent: Have single quotes represent characters
Message-ID: <20240415042631.6310d78b@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In parsing the print fmt parameters, the code currently treats both single
and double quotes the same. But they are not. Double quotes represent
strings and single quotes represent characters.

A character could be used as a number as well, so it needs to be treated
as such.

Link: https://lore.kernel.org/all/20240315174900.14418f22@booty/

Fixes: 6582b0aea1cc ("tools/events: Add files to create libtraceevent.a")
Reported-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index d607556ea1a9..61b09662f28f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -3732,8 +3732,19 @@ process_arg_token(struct tep_event *event, struct tep_print_arg *arg,
 		arg->atom.atom = atom;
 		break;
 
-	case TEP_EVENT_DQUOTE:
 	case TEP_EVENT_SQUOTE:
+		arg->type = TEP_PRINT_ATOM;
+		/* Make characters into numbers */
+		if (asprintf(&arg->atom.atom, "%d", token[0]) < 0) {
+			free_token(token);
+			*tok = NULL;
+			arg->atom.atom = NULL;
+			return TEP_EVENT_ERROR;
+		}
+		free_token(token);
+		type = read_token_item(event->tep, &token);
+		break;
+	case TEP_EVENT_DQUOTE:
 		arg->type = TEP_PRINT_ATOM;
 		arg->atom.atom = token;
 		type = read_token_item(event->tep, &token);
-- 
2.43.0

