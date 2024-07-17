Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B03184F;
	Wed, 17 Jul 2024 17:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721238450; cv=none; b=WG1fayJwYp2VWJ3CG+1Y6oHEhDPr0V/6DZsnXTd973NEYxGv9zuVdBTtOwYjgoKxH9fCCgXqNTGPCeBuW1/BFQsPmSSiUqbwNzZCBt3kP/m3a7uozvb6fHAbHF0oFl/V1n1OxfK5kUKIEV8jG14Nt/sc5dOveU5+TFCEFGVAl3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721238450; c=relaxed/simple;
	bh=tnjtNM4Sj/0t9WhNNHq9CQZPCLxHpd0e8rB1onf2S9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hfxX4ERJ4WNz3kko5sazTrmG7AzxMLl+5flcfxJvAG/bKO0B4ZB2hm7T7tiFLFuFBhvmNuAKmfdDznPzVpiOMJdcsoXQIkbQxax+Q7y08G+Y2jTfvxVZDmIaxUQ4E8+cnWKeaK5lyCr//YBXxTNtpqQZdftHjktXMVJ2VLruGt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Guilherme Amadio <amadio@gentoo.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ian Rogers <irogers@google.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Leo Yan <leo.yan@arm.com>,
	linux-perf-users@vger.kernel.org,
	linux-trace-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] perf build: libtraceevent, libtracefs feature check with pkg-config
Date: Wed, 17 Jul 2024 19:47:34 +0200
Message-Id: <20240717174739.186988-1-amadio@gentoo.org>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240717123147.17169873@rorschach.local.home>
References: <20240717123147.17169873@rorschach.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series is a continuation of recent work to use pkg-config for feature
checks for libtraceevent and libtracefs.

The original intention of the first patches was to fix build issues with
libtracefs installed with its meson build system (used in Gentoo), which
installs headers in a different directory as the make build system. This has
been reported here: https://github.com/rostedt/libtracefs/issues/3

In order to fix the feature check, instead of using #include <tracefs/tracefs.h>
in tools/build/feature/test-libtracefs.c, we need to use #include <tracefs.h>
and add the appropriate -I flag for the include directory, which is what is now
done with pkg-config. An unintended consequence of this (reported by Thorsten)
was that other tools which also perform the same feature check for libtracefs
became broken, because the initial patch only set the include flag for perf in
tools/perf/Makefile.config.

This patch series fixes this issue by moving the feature check flags to the file
tools/build/Makefile.feature, which ensures the flags get set for all tools that
need them. I tried to write the new code in a way that would be easily extensible
to other dependencies that may be used via pkg-config as well.

There is no change in this new submission relative to the last (which has been
tested by Thorsten to fix the build issue in Fedora). The only change has been
to add in CC Steven Rostedt and the list linux-trace-devel@vger.kernel.org.

Best regards,
-Guilherme

Guilherme Amadio (5):
  perf build: Warn if libtracefs is not found
  tools: Make pkg-config dependency checks usable by other tools
  tools/verification: Use pkg-config in lib_setup of Makefile.config
  tools/rtla: Use pkg-config in lib_setup of Makefile.config
  tools/latency: Use pkg-config in lib_setup of Makefile.config

 tools/build/Makefile.feature          | 18 ++++++++++++++++++
 tools/perf/Makefile.config            | 13 +++++--------
 tools/tracing/latency/Makefile.config |  3 ++-
 tools/tracing/rtla/Makefile.config    |  3 ++-
 tools/verification/rv/Makefile.config |  3 ++-
 5 files changed, 29 insertions(+), 11 deletions(-)

-- 
2.39.3

