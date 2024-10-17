Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FAD227B80
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729195546; cv=none; b=kXRrgT+CfukmkTmcSIWSNEjNoH3BF8CxOM5twXG4S+TE5ELzqgSeAPQiQcLsuQ24nGS2yqB7KMQjovLMI/2wwgZSQ6SSBWfbobHlNoSq5Ap7SNBPtRErYo7d6g3LJspCzr4r1GqvDlE6diNWZAFjjc7C2Gi7G8u88/tcLjPLhYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729195546; c=relaxed/simple;
	bh=t7RcUw71NYQAfnKIORknyU5w/d6g0Vgp43d+eKzOZa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sGUl5hwym9Aay/Ligx+OfuxZHFrs94eCIESMLi9i+Ev9DDi4vaJUudDK7hQLTkLnIRfTshrStdg1hpAma1HyBTRLv+fo/bWboGgAmnrLCOr+qBsa79Hc+EUwY7UnmRFZbTwF4E9FRWW88jSTFAe5KfxhnfTx02vvPIljSNI+V2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FFCC4CED4;
	Thu, 17 Oct 2024 20:05:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t1Wl8-00000003uh5-1z36;
	Thu, 17 Oct 2024 16:06:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracefs utest: Fixes and new tests
Date: Thu, 17 Oct 2024 16:03:21 -0400
Message-ID: <20241017200609.932728-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

- Add a test to test traceefs_dynevent_get_all() more thoroughly

- Fix the min percent testing in case of large sub-buffers

- Do not test more events than can be held in the ring buffer.

Steven Rostedt (Google) (3):
  libtracefs utest: Add test to check handling multiple dynamic events
  libtracefs utest: Fix min percent test
  libtracefs utest: Do not test more events than what the ring buffer
    can hold

 utest/tracefs-utest.c | 184 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 183 insertions(+), 1 deletion(-)

-- 
2.45.2

