Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174E938DDB
	for <linux-trace-devel@vger.kernel.org>; Sat,  2 Aug 2025 02:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754102414; cv=none; b=rpjoEXGt1lMYNSRjobW69gOuZV21ptL6WYkeKbqfoqlHfYNOGV+tHhQ9tFm0vN9Kei5HlLe9g5H9L8M6LMKhwHlV+ufXtbiGOH2mBTApZ8AxZYtE4G6sKNvfZAXn97BpvcLCWyuZbwWLre6fjupmF6Asw2iBYNvrfQpCMb+ooxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754102414; c=relaxed/simple;
	bh=fg2hLl0G2iJOJq4yz8PejV2Rtk/+IGe3RD07TE5/beA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gaVqaYDKJWgYAxQc8qwY5ZPLT/rZTrtrCaTuyz9Hdo7eFklmrHg72LMEpzzJSSGp9MrxUDXxqg4pct8ZEgrk8S41kNwIEgkPPTA+oxsiSfXIJdT/jiC4BJgyLz9NzoM7OPr0QTHpqkqYr0pXw2IecnMwjV2qV5X7/1Tw/zmi5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB77FC4CEE7;
	Sat,  2 Aug 2025 02:40:13 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98.2)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1ui2Al-00000007wiw-3JpV;
	Fri, 01 Aug 2025 22:40:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/2] libtraceevent: Add BTF parsing for function arguments
Date: Fri,  1 Aug 2025 22:39:16 -0400
Message-ID: <20250802024035.1893851-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Changes since v1: https://lore.kernel.org/all/20250731185559.1644753-1-rostedt@goodmis.org/

- Fixed whitespace issues

Steven Rostedt (Google) (2):
  libtraceevent: Add loading of BTF to the tep handle
  libtraceevent: Add man page for the new BTF functions

 Documentation/libtraceevent-btf.txt | 158 ++++++++++
 Documentation/libtraceevent.txt     |   5 +
 include/traceevent/event-parse.h    |   5 +
 plugins/plugin_function.c           |  15 +-
 src/Makefile                        |   1 +
 src/event-parse-local.h             |   6 +
 src/event-parse.c                   |   2 +
 src/trace-btf.c                     | 449 ++++++++++++++++++++++++++++
 8 files changed, 631 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/libtraceevent-btf.txt
 create mode 100644 src/trace-btf.c

-- 
2.47.2

