Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DA81B393A
	for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729842127; cv=none; b=AQfRZe7I/GNGxogf5QuJwHil3We8V3cfgF3Ht4bOUCHruKhA/CB0mxRyp46ADkBvH7E5THwexoxM7xDEh7N5c6A9vGDl38NDrqu7k5H5xHM/hOjMXWp9vxEnjOgZ9syL6e6yTZScV9W/m+K6GDCSyEy0DMJal+obcSm6K6crClQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729842127; c=relaxed/simple;
	bh=XYzpAVSMz7B69IesBaZAQ+E2z2fPDrMcx60jE/Dmwaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O6l7q0/BcYrkfPT70GIikg2GHTgPvTQsb/21X+Lbndf7rXKl3AyqoqCthULbRBzkl67D4zQBWedNQ1LZVcK4CdD/u6K3HrNGC+wb14IyTvOjKJ+2q308ugVacUw6tFZaTyC6YRXMvi1k+v6Wi0yvVwfC3a/GxPpwzRFIjWmOn9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E13C4CECC;
	Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t4Ey8-00000004r2e-3wpv;
	Fri, 25 Oct 2024 03:42:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtraceeval: Updates
Date: Fri, 25 Oct 2024 03:40:43 -0400
Message-ID: <20241025074247.1157166-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add more updates to make it easier to use the library, and simplify task-eval.

Steven Rostedt (Google) (4):
  libtraceeval task-eval: Add wake up latency
  libtraceeval samples: Add PARKED and DEAD fields
  libtraceevent: Add DECLARE_TRACEEVAL_<types>
  libtraceeval: Add traceeval_type_index() API

 Documentation/libtraceeval-init.txt |  52 ++-
 Documentation/libtraceeval.txt      |   4 +
 include/traceeval.h                 |  34 ++
 samples/task-eval.c                 | 499 ++++++++++++++++++++--------
 4 files changed, 434 insertions(+), 155 deletions(-)

-- 
2.45.2

