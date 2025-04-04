Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92C207DFE
	for <linux-trace-devel@vger.kernel.org>; Fri,  4 Apr 2025 16:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783238; cv=none; b=t/sr9LsTea2WUUoN48V1rKg6ewGR0W2qMi9WulX5ivbyMLC3PBj7kqoVBxFlT2WhouRTl3yPjHPBj2C+GO0P6Jf8aMJGMrwaSYLdeOgWEO0Qz/Dp9TtfJWhV0yubrzIMTtZith4U9VfxL+VCr9B2MlQ9NffpH1ljqjgTafGOB6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783238; c=relaxed/simple;
	bh=WZ5ryJRhnNUeeO2BCNhrZFIiJnbPubObBUA10yCizgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NoFXzVPvVgiM0BWl3qmgxa3c4AuPzuiY+7FGkaXL9+6GQMXPe7daja4eIF7692MG6KbQBrHYxR2efkvE+C+ZHNBd19mIC1xxqqKqjHQjTdMUPEy26lIbsosg9cU9pCIUJO6ZvN5hlzHEuWrnkcdEZgehU7bil3VFqhGF5m4kci0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8704C4CEE9;
	Fri,  4 Apr 2025 16:13:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1u0jhC-000000070wV-0qeS;
	Fri, 04 Apr 2025 12:15:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Oleh Matiusha <omatiush@cisco.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtracefs: Update sqlhist bison and flex
Date: Fri,  4 Apr 2025 12:12:09 -0400
Message-ID: <20250404161504.1671790-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The way that git doesn't save timestamps of files causes the flex and bison
source to regenerate the flex and bison output files. This can be annoying
when the source of the flex and bison files are not updated. Worse, it can
cause the build to fail if the system doesn't have flex nor bison.

Instead add a new make target: sqlhist_remake

The bison and flex utilities will only be run when this target is specified.
Otherwise it will not build the output file from bison nor flex.

Steven Rostedt (Google) (2):
  libtracefs: Add make sqlhist_remake to run bison and flex
  libtracefs: Rerun bison and flex via make sqlhist_remake

 Makefile          |   3 +
 src/Makefile      |  14 +-
 src/sqlhist-lex.c |  66 +++---
 src/sqlhist.l     |   2 +
 src/sqlhist.tab.c | 504 +++++++++++++++++++---------------------------
 src/sqlhist.tab.h |  14 +-
 src/sqlhist.y     |   1 +
 7 files changed, 262 insertions(+), 342 deletions(-)

-- 
2.47.2

