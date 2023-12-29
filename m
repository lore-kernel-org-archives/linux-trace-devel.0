Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129548BF3
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02C7C433C7;
	Fri, 29 Dec 2023 03:10:48 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rJ3Hf-00000000Hm9-037f;
	Thu, 28 Dec 2023 22:11:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] trace-cmd library: Fixes and add a reset
Date: Thu, 28 Dec 2023 22:10:12 -0500
Message-ID: <20231229031138.68313-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

A couple of fixes, plus adding a way to reset the iterator.

Steven Rostedt (Google) (3):
  trace-cmd library: Fix tracecmd_iterate_events_multi() CPU clean up
  trace-cmd library: Add back setting errno to zero in
    tracecmd_stack_tracer_status()
  trace-cmd library: Add tracecmd_iterate_reset()

 .../libtracecmd/libtracecmd-iterate.txt       | 10 +++++-
 Documentation/libtracecmd/libtracecmd.txt     |  1 +
 include/trace-cmd/trace-cmd.h                 |  2 ++
 lib/trace-cmd/trace-input.c                   | 34 ++++++++++++++++++-
 lib/trace-cmd/trace-util.c                    |  1 +
 5 files changed, 46 insertions(+), 2 deletions(-)

-- 
2.42.0

