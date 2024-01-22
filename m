Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4345810A
	for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705941832; cv=none; b=b9nQWZUO/MWRvI+h8QIUqvpRLDDYrTRF9sAB0qY/CU8UsBli4lPIjEB+yvLStVFu6hb8eCSbgrMZ0C0KzL/xusB9CFiKjEBNz4PjrALtF/06aZbcKYXtzq7ErcLgExNAHxfA19kowwtWKA1kWmt95vLEOi+gmBpxaGeaapmzqNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705941832; c=relaxed/simple;
	bh=Fxr4Op40KkbCjFAbzIxTIyAtloA7F4LN3zJlEBisK3c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pjGa8WvCJRra7m4QaxduAFPh/fZ+f1byAWndot+4dHp+aTHkE7ZXKWqywqPlz60SAYNAR8uYVJBuHzh6dBjxwTC540m93mK7C1OQtV1oZnin1gYQqGjtFLZoIk/XYys1yjkSh6ZgbZEjR7BiRltHoHo+RHqEQU75Xokj8Ayw7gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1EBE1FB;
	Mon, 22 Jan 2024 08:44:35 -0800 (PST)
Received: from e126645.nice.arm.com (e126645.nice.arm.com [10.34.100.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1004F3F5A1;
	Mon, 22 Jan 2024 08:43:48 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v2 0/7] trace-cmd: split: Handle splitting files with multiple instances
Date: Mon, 22 Jan 2024 17:43:29 +0100
Message-Id: <20240122164336.167256-1-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Pierre Gondois (7):
  trace-cmd split: Small fixes
  trace-cmd split: Correctly split with start/end/time-window parameters
  trace-cmd split: Store instances in local list
  trace-cmd split: Add functions to generate temp files
  trace-cmd split: Handle splitting files with multiple instances
  trace-cmd split: Enable support for buffer selection
  trace-cmd split: Update usage

 tracecmd/trace-split.c | 517 +++++++++++++++++++++++++++++++++--------
 tracecmd/trace-usage.c |   9 +-
 2 files changed, 434 insertions(+), 92 deletions(-)

-- 
2.25.1

