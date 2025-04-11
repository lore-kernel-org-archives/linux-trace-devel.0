Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B9DD299
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 01:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744334390; cv=none; b=LoemHzv5Kb8xchB7oSM7NklcavSjYP1ySlj/vGzVNBZRwZ+tZRSk/ooPwbdzeFhJFz28J52GQY2DlOfI722piifyiDqzUbkNZfytErYzHKY6B4mCB2nM9P2ruIH1MVOIcoMYcfXpeAU4QtVxzIptsiD8TRE0otDetsXXDseFK2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744334390; c=relaxed/simple;
	bh=kyJq5YoAU1xOvPeAGKQnJGq3Ph5zgN1cgypYkz82360=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=gwBqAOCq5/ctJ3O3AJWJ38+LpppWYzwlSb3CexbVXLviGRPpBPBsPHrxm8ofsoaIx7WE1Q2awlm5x2XTfy4supMFysTLgW/iXc47njp2FNxMGazBgLzqCRTx9Wd3BkwTIhC2+rhiirXFETwI92pH/k+Jpc8evg0SytchHV+7PJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDA7C4CEDD
	for <linux-trace-devel@vger.kernel.org>; Fri, 11 Apr 2025 01:19:49 +0000 (UTC)
Date: Thu, 10 Apr 2025 21:21:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Have tracefs_sql() cast handle stacktrace
Message-ID: <20250410212112.45e673ad@gandalf.local.home>
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

A histogram can have a "stacktrace" type. Allow casts to make that:

  # sqlhist select cast '('start.stack as stacktrace')' from sleep_lat as start
  echo 'hist:keys=stack.stacktrace' > /sys/kernel/tracing/events/synthetic/sleep_lat/trigger

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 67be678..30c8ccc 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1450,6 +1450,10 @@ static int verify_field_type(struct tep_handle *tep,
 		if (tfield->flags & (TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY))
 			goto fail_type;
 		ret = TRACEFS_HIST_KEY_BUCKETS;
+	} else if (!strcmp(type, "stacktrace")) {
+		if (!(tfield->flags & (TEP_FIELD_IS_ARRAY)))
+			goto fail_type;
+		ret = TRACEFS_HIST_KEY_STACKTRACE;
 	} else {
 		parse_error(sb, field->raw,
 			    "Cast of '%s' to unknown type '%s'\n",
-- 
2.47.2

