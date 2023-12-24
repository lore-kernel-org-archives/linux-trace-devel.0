Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE56D2F0
	for <linux-trace-devel@vger.kernel.org>; Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645D5C433C9;
	Sun, 24 Dec 2023 19:17:04 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rHTzL-00000004VxD-2qEc;
	Sun, 24 Dec 2023 14:18:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/6] libtraceevent/kbuffer: Add more kbuffer APIs
Date: Sun, 24 Dec 2023 14:15:57 -0500
Message-ID: <20231224191813.1076074-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preparation to add more advanced kbuffer functionality to libtracefs,
some kbuffer APIs are needed. This will also allow libtracefs to add APIs
for the upcoming memory mapping of the kernel ring buffer.

Steven Rostedt (Google) (6):
  libtraceevent: Add tep_get_sub_buffer_commit_offset()
  libtraceevent: Fix tep_kbuffer() to have kbuf assign long_size
  kbuffer: Add kbuffer_read_buffer()
  kbuffer: Add kbuffer_dup()
  kbuffer: Add kbuffer_subbuffer() API
  kbuffer: Add kbuffer_refresh() API

 .../libtraceevent-kbuffer-create.txt          |  30 ++-
 Documentation/libtraceevent-kbuffer-read.txt  |  19 +-
 Documentation/libtraceevent-page_size.txt     |   9 +
 Documentation/libtraceevent.txt               |   5 +
 include/traceevent/event-parse.h              |   1 +
 include/traceevent/kbuffer.h                  |   4 +
 src/event-parse-api.c                         |  15 ++
 src/kbuffer-parse.c                           | 223 ++++++++++++++++--
 src/parse-utils.c                             |   5 +
 9 files changed, 287 insertions(+), 24 deletions(-)

-- 
2.42.0

