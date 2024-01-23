Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C6A5F541
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706017356; cv=none; b=oaQf5U0M5TQ4K0QwY3/kdb+x4iLtzwhvKtjdK2B9qJDnRX3GayJnX2aAZKfF5NUgrd3XxhlBlPsotVRGNZuD3cFIJqhPwohz4OcWDbEIcE+Z9ySjrf9qCtoK+aiDOkT8dcB5HFCb/MKfa174ljHGar4l/2OkDvl5t0XQqAUsVr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706017356; c=relaxed/simple;
	bh=MBs/uFLNvYEHKTjTMU0pp/TiO9BQG2p9QW29G/nYNCo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VWpaTy6K/KVSE0+uWNakST83N3iOIis7RVt2P+xdZ7vCFX9fyC06YTJBr/b4oa4RfesMz0zVXk7P5P/wHSYllFVNVHqCueB1wAK8Y04vp9m95GDBF3Bq/WoYVZaytI1WP9T8Fc1roQxlP+Z14bm2ZkatBxDDXqpX1UBFgve7GHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C1CC1FB;
	Tue, 23 Jan 2024 05:43:19 -0800 (PST)
Received: from e126645.home (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9FBAE3F7CE;
	Tue, 23 Jan 2024 05:42:32 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v3 0/5] trace-cmd: split: Handle splitting files with multiple instances
Date: Tue, 23 Jan 2024 14:42:10 +0100
Message-Id: <20240123134215.385415-1-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

V3:
- Add error handling for strdup() calls.
- Fix bug described at [2]: the split command kept generating
  split files forever when the '-r' option was provided.
  A new handle was used in each loop, meaning the input file was
  being parsed again from the beginning.
- Remove the 2 first patch accepted in v2.
V2:
- Add 'trace-cmd split: Enable support for buffer selection' to
  handle instance selection with the 'trace-cmd' split command.
- Rename patches as 'trace-cmd: split' -> 'trace-cmd split'.
- Correctly free allocated memory in different lists.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357

Splitting trace files having multiple buffer instances discards
side-buffers . I.e., only the main buffer is preserved in the
resulting split trace files. This patch-set intends to fix this.

As a continuation of the bugzilla, support to allow selecting
buffer instances is added to the 'trace-cmd split' command [1].
This support implies adding new '-B/--top' parameters.

Also:
- Fix a side issue preventing to provide start/end timestamps
  along with a time-window parameters.
- Update trace-cmd split usage

[1] https://lore.kernel.org/all/20240119122511.440d8f0a@gandalf.local.home/
[2] https://lore.kernel.org/all/20240122192346.5a9035e2@gandalf.local.home/

Pierre Gondois (5):
  trace-cmd split: Store instances in local list
  trace-cmd split: Add functions to generate temp files
  trace-cmd split: Handle splitting files with multiple instances
  trace-cmd split: Enable support for buffer selection
  trace-cmd split: Update usage

 tracecmd/trace-split.c | 550 ++++++++++++++++++++++++++++++++++-------
 tracecmd/trace-usage.c |   9 +-
 2 files changed, 468 insertions(+), 91 deletions(-)

-- 
2.25.1

