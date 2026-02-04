Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC48263F44
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 01:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770167762; cv=none; b=KB24ZVAscwGxqUKDfmnf/JRB20exb643fF7uxtmpffEEy0tGGB9DEYFhR3Ofi/WsxcXYMzEyIOv8dcOckL7YBBPKWOhZeakqMHmdFbUGencKVjt822NovPHtes/8hzvd4LSgbrDfNe+p2dDXbhw7/ojhVWZRMACnZ0O/Bw7WHCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770167762; c=relaxed/simple;
	bh=1bdLyIS4QkBX4PFCirddYKG1lrFpKMfbRcj5k+bzquQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSBt/lGijQyWuNho3g4U95sB3AW2BQA5/Mn5fMoeVPTuApoi8w70HtMxGmtSai2xuODgsfMGDbm6F2QC1Mali8RCEvrNofkaUZzq24VxHh3FgXjDm3UkWQSQCimjnAaiRY0S+OhqvIvP2kkbNym6CI8w1QPkqai3ehdQxCZxxow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B7BC116D0;
	Wed,  4 Feb 2026 01:16:00 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnRVP-00000008xVD-0178;
	Tue, 03 Feb 2026 20:16:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd extract: Do not delete instances after extraction
Date: Tue,  3 Feb 2026 20:14:55 -0500
Message-ID: <20260204011629.2135260-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260204011629.2135260-1-rostedt@goodmis.org>
References: <20260204011629.2135260-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

After trace-cmd extract is finished reading an instance, it deletes that
instance. That is incorrect behavior.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1707345b343f..30727d613492 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -7454,6 +7454,9 @@ void trace_extract(int argc, char **argv)
 		/* Some instances may not be created yet */
 		if (instance->tracing_on_init_val < 0)
 			instance->tracing_on_init_val = 1;
+
+		/* Keep all instances */
+		instance->flags |= BUFFER_FL_KEEP;
 	}
 
 	/* Extracting data records all events in the system. */
-- 
2.51.0

