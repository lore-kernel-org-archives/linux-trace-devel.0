Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E302EAFF
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 08:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD2491FB;
	Fri, 12 Jan 2024 00:40:42 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.77.163])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8456B3F64C;
	Fri, 12 Jan 2024 00:39:55 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH 0/5] trace-cmd: split: Handle splitting files with multiple instances
Date: Fri, 12 Jan 2024 09:39:40 +0100
Message-Id: <20240112083945.1361293-1-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357

Splitting trace files having multiple buffer instances discards
side-buffers . I.e., only the main buffer is preserved in the
resulting split trace files. This patch-set intends to fix this.

Also:
- Fix a side issue preventing to provide start/end timestamps
  along with a time-window parameters.
- Update trace-cmd split usage

Pierre Gondois (5):
  trace-cmd: split: Small fixes
  trace-cmd: usage: Update usage for trace-cmd split
  trace-cmd: split: Store instances in local list
  trace-cmd: split: Add functions to generate temp files
  trace-cmd: split: Handle splitting files with multiple instances

 tracecmd/trace-split.c | 231 +++++++++++++++++++++++++++++------------
 tracecmd/trace-usage.c |   3 +-
 2 files changed, 167 insertions(+), 67 deletions(-)

-- 
2.25.1

