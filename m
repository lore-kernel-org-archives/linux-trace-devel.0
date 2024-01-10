Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2554F88F
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 23:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281B0C43390;
	Wed, 10 Jan 2024 23:02:03 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNhbE-00000000Usx-2ZKM;
	Wed, 10 Jan 2024 18:03:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd record: Add updates for subbuffer size
Date: Wed, 10 Jan 2024 18:00:27 -0500
Message-ID: <20240110230303.118668-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add --subbuf-size option to trace-cmd record, and also save and restore the
previous settings of what they were if they are modified.

Steven Rostedt (Google) (2):
  trace-cmd record: Add --subbuf-size option
  trace-cmd record: Reset buffer_size and subbuf_size when done

 .../trace-cmd/trace-cmd-record.1.txt          | 15 ++++
 tracecmd/include/trace-local.h                |  3 +
 tracecmd/trace-record.c                       | 68 ++++++++++++++-----
 tracecmd/trace-usage.c                        |  1 +
 4 files changed, 71 insertions(+), 16 deletions(-)

-- 
2.43.0

