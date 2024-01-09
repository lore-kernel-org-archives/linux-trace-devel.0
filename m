Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F893D98D
	for <linux-trace-devel@vger.kernel.org>; Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C7EC433F1;
	Tue,  9 Jan 2024 20:50:14 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rNJ45-00000000JKI-15NV;
	Tue, 09 Jan 2024 15:51:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/4] libtracefs: More updates and fixes to mmap code
Date: Tue,  9 Jan 2024 15:48:55 -0500
Message-ID: <20240109205112.74225-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Changed the iterator to use memory mapping when possible, which also
triggered bugs in the unit tests. Those were fixed here too.

Steven Rostedt (Google) (4):
  libtracefs: Unmap mmap mapping on tracefs_cpu close
  libtracefs: Use tracefs_cpu_*_buf() calls for iterator
  libtracefs: Use mmapping for iterating raw events
  libtracefs: Have tracefs_cpu_flush(_buf)() use mapping

 src/tracefs-events.c | 57 +++++++++++++-------------------------------
 src/tracefs-record.c | 11 +++++++++
 2 files changed, 27 insertions(+), 41 deletions(-)

-- 
2.43.0

