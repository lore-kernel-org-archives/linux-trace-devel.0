Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3552E107BD
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CFCC433C7;
	Thu, 28 Dec 2023 21:53:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKo-00000000EIc-33bv;
	Thu, 28 Dec 2023 16:54:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 00/22] libtracefs: Several updates
Date: Thu, 28 Dec 2023 16:51:55 -0500
Message-ID: <20231228215433.54854-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Spent the days between Christmas and New Years doing some updates
to the libtracefs library!

Changes since v1: https://lore.kernel.org/all/20231228203714.53294-1-rostedt@goodmis.org/

- Updated the minimum version of libtraceevent for when it is needed.

- re-arranged the patches a bit.

- Removed a patch that was not ready yet.


Steven Rostedt (Google) (22):
  libtracefs Documentation: Fix tracefs_event_file_exists() issues
  libtracefs testing: Use one tep handle for most tests
  libtracefs: Free "missed_followers" of instance
  libtracefs: Free buf in clear_func_filter()
  libtracefs: Free tracing_dir in case of remount
  libtracefs: Free dynamic event list in utest
  libtracefs: Reset tracing before and after unit tests
  libtracefs: Add API to remove followers from an instance or toplevel
  libtracefs: Increase splice to use pipe max size
  libtracefs: Add tracefs_instance_file_write_number()
  libtracefs: Add API to read tracefs_cpu and return a kbuffer
  libtracefs: Add tracefs_instance_get/set_buffer_percent()
  libtracefs: Add tracefs_instance_clear() API
  libtracefs utest: Add test to test
    tracefs_instance_set/get_buffer_percent()
  libtracefs: Add kerneldoc comments to
    tracefs_instance_set_buffer_size()
  libtracefs: Add tracefs_load_headers() API
  libtracefs: Add API to extract ring buffer statistics
  libtracefs: Add tracefs_instance_set/get_subbuf_size()
  libtracefs: Add TIMESTAMP_USECS_DELTA to simplify SQL timestamp
    compares
  libtracefs: Also clear max_graph_depth on reset
  libtracefs: Add PID filtering API
  libtracefs: Add updating and reading snapshot buffers

 Documentation/libtracefs-cpu-buf.txt          | 171 ++++
 Documentation/libtracefs-cpu-open.txt         |  16 +-
 Documentation/libtracefs-cpu.txt              |   3 +
 Documentation/libtracefs-events-file.txt      |   3 +-
 Documentation/libtracefs-events-tep.txt       |   7 +-
 Documentation/libtracefs-filter-pid.txt       | 181 +++++
 .../libtracefs-instances-file-manip.txt       |   9 +-
 Documentation/libtracefs-instances-manage.txt |   9 +-
 Documentation/libtracefs-instances-stat.txt   | 183 +++++
 Documentation/libtracefs-instances-subbuf.txt | 152 ++++
 Documentation/libtracefs-instances-utils.txt  |  28 +-
 Documentation/libtracefs-iterator.txt         |  38 +-
 Documentation/libtracefs-sql.txt              |  16 +
 Documentation/libtracefs.txt                  |  39 +
 include/tracefs-local.h                       |  11 +
 include/tracefs.h                             |  51 ++
 meson.build                                   |   2 +-
 samples/Makefile                              |   3 +
 src/Makefile                                  |   1 +
 src/tracefs-events.c                          | 218 ++++-
 src/tracefs-filter.c                          | 132 +++
 src/tracefs-instance.c                        |  84 ++
 src/tracefs-record.c                          | 234 +++++-
 src/tracefs-sqlhist.c                         |  64 +-
 src/tracefs-stats.c                           | 162 ++++
 src/tracefs-utils.c                           |  30 +-
 utest/tracefs-utest.c                         | 755 +++++++++++++++++-
 27 files changed, 2506 insertions(+), 96 deletions(-)
 create mode 100644 Documentation/libtracefs-cpu-buf.txt
 create mode 100644 Documentation/libtracefs-filter-pid.txt
 create mode 100644 Documentation/libtracefs-instances-stat.txt
 create mode 100644 Documentation/libtracefs-instances-subbuf.txt
 create mode 100644 src/tracefs-stats.c

-- 
2.42.0

