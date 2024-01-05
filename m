Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D391CA85
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 05:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631C1C433C7;
	Fri,  5 Jan 2024 05:20:35 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLceM-00000000xZr-3BnR;
	Fri, 05 Jan 2024 00:21:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs synthetic: Remove multiple adding of action in tracefs_synth_save()
Date: Fri,  5 Jan 2024 00:21:00 -0500
Message-ID: <20240105052141.228999-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240105052141.228999-1-rostedt@goodmis.org>
References: <20240105052141.228999-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The tracefs_synth_save() did both:

	*synth->next_action = action;
	synth->next_action = &action->next;

As well as:

	add_action(synth, action);

Which does the same thing. Do not add the action twice, as it causes the action
list to link on itself and create an infinite loop when traversed.

Fixes: 5e5a6cddcced9 ("libtracefs: Add API tracefs_synth_save()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-hist.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index ecfce7442176..5f32ec305409 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1838,8 +1838,6 @@ int tracefs_synth_save(struct tracefs_synth *synth,
 
 	action->type = ACTION_SAVE;
 	action->handler = type;
-	*synth->next_action = action;
-	synth->next_action = &action->next;
 
 	save = strdup(".save(");
 	if (!save)
-- 
2.42.0

