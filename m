Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DFC1B393B
	for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729842127; cv=none; b=BcUjqx7XmdjIbKAb5pp4NWwdavzjPr7gcUic3YIiIslVIm7GSh8gNsIuwiA5rG7Ar1XV6u9sZr+aBYXGHSte0iBv1B8M8TACx0Kpkz7BHEIrs9ZdEF3rVKIFz3pYOkufkysX1aF076LTDh7FnDtNz/di/9nF5gryyZiIjVHpfFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729842127; c=relaxed/simple;
	bh=/cNBE4kKCXd0IMrlmibZR3WdRLKURjZ435iI2NvnmSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph3qCPamhT5yuFsPKKnxEOIhM6tq0LjanD3qxLNcT3GP+AwkCZZ3rljgRPPnLJKVUpZqR+zw4/TGXhBMLQYc0kDUfDt57O9YKDW52L/ilqogwrTeyeji7FpWSIzQINEgZbRc2OrMN6UesLZzMBDuAxk45U8ZglUcnvCG+av9kGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18058C4AF09;
	Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t4Ey9-00000004r2k-02aD;
	Fri, 25 Oct 2024 03:42:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] libtraceeval samples: Add PARKED and DEAD fields
Date: Fri, 25 Oct 2024 03:40:45 -0400
Message-ID: <20241025074247.1157166-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025074247.1157166-1-rostedt@goodmis.org>
References: <20241025074247.1157166-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

get_stop_state() was returning PREEMPT when a task was really in the
PARKED or DEAD state. Check those as well.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 7b709f715332..47ccce8e4737 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -91,7 +91,9 @@ enum sched_state {
 	SLEEP,
 	IDLE,
 	ZOMBIE,
+	PARKED,
 	EXITED,
+	DEAD,
 	OTHER,
 	WAKEUP,
 };
@@ -749,6 +751,10 @@ static int get_stop_state(unsigned long long val)
 		return ZOMBIE;
 	if (val & 0x20)
 		return EXITED;
+	if (val & 0x40)
+		return PARKED;
+	if (val & 0x80)
+		return DEAD;
 	return PREEMPT;
 }
 
-- 
2.45.2

