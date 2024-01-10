Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1A51FA6
	for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2024 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0578FC43394;
	Wed, 10 Jan 2024 03:00:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNOqD-00000000LLY-2B3v;
	Tue, 09 Jan 2024 22:01:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/7] libtracefs: More fixes for memory mapping ring buffer API
Date: Tue,  9 Jan 2024 21:51:44 -0500
Message-ID: <20240110030116.81837-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now all the read APIs support memory mapped ring buffer.

For those that use splice and pipe, if the tcpu is memory mapped, it will
then fall back to copying directly from the memory map.

Also added a tracfes_mapping_is_supported() API to test if the kernel and
library support memory mapping.

And updated the tests to use memory mapped ring buffers when possible.

Steven Rostedt (Google) (7):
  libtracefs: Have mapping work with the other tracefs_cpu* functions
  libtracefs: Have tracefs_mmap_read() include subbuf meta data
  libtracefs: Have nonblock tracefs_cpu reads set errno EAGAIN
  libtracefs: Fix tracefs_mmap() kbuf usage
  libtracefs: Call mmap ioctl if a refresh happens
  libtracefs: Add tracefs_mapped_is_supported() API
  libtracefs utest: Add tests to use mapping if supported

 Documentation/libtracefs-cpu-map.txt | 38 ++++++++++++---
 Documentation/libtracefs.txt         |  1 +
 include/tracefs.h                    |  1 +
 src/tracefs-events.c                 |  8 +---
 src/tracefs-mmap.c                   | 28 +++++++++--
 src/tracefs-record.c                 | 72 +++++++++++++++++++++++++++-
 utest/tracefs-utest.c                | 69 ++++++++++++++++++--------
 7 files changed, 176 insertions(+), 41 deletions(-)

-- 
2.43.0

