Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE19126F05;
	Fri,  2 Feb 2024 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706911504; cv=none; b=AEf1MDc50sIOPZOTXzmW/z3RoCEw+3QUJ8XkRoc9RSe8od5lyjc2rBYHFjbWJyjeW57GiFa/Qm8w40VmS0nPYmRicyH/KXVRAJbWWLAG6LNyGPCHtKJ8IkS48RjGXlO8PgpLyXDAiSaGnTehnslUAzyi3AHiy0SA5+wFUqESUww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706911504; c=relaxed/simple;
	bh=ksRwB6y7Bf3D1VViK194iwXHp5tebaWmPZdpxqK0sY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnA+i7v3d3liwQtiQbnX2FuNxv3XX+hkxS+AorjE3vfrYxZfFHW614gjn+rw2D7ntfVaHMEOP5QcfjbGVuz2jB9MTV+WsDXUEjwzNc5nUOHadzcA1/rSOS8KWE0HyHb29DsCQsL6RXYibpSXv9yFTLJGLTE5ORCORC41xrwTEzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m77Rje8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m77Rje8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86C7C43142;
	Fri,  2 Feb 2024 22:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706911504;
	bh=ksRwB6y7Bf3D1VViK194iwXHp5tebaWmPZdpxqK0sY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m77Rje8KR9qi8D7/IwR6G3a4rHlf/J2LNxrkGo9chaQfeUpCtzwJCtvn2yEtaELOR
	 bPS5LmLOZlDx3zlMgBjlypofa0Av7AgggOIMMEYWCI9fEsu7vSpl2r8xY3zcohzotp
	 Jwir98s5VsJsH9Y5CbUem2Ye+RenIHOZDeK+HevXhlTta9PchwxswwTv/w1RAXO4eX
	 QPb0eL+G+aoJ6wQ5xEADdI3PXuLlIn77WFMMCqqgoB1txsrQ3/i+qa4LwzVnV9qzPw
	 jxLWHtmv0kU2eQnID/E4vs9JnoJ1QnmzjGIgA3giByztmpgvXLS46P1QrZGYS3JgND
	 Y9jq+KcezyAmQ==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stephane Eranian <eranian@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-toolchains@vger.kernel.org,
	linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/14] perf map: Add map__objdump_2rip()
Date: Fri,  2 Feb 2024 14:04:49 -0800
Message-ID: <20240202220459.527138-5-namhyung@kernel.org>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
In-Reply-To: <20240202220459.527138-1-namhyung@kernel.org>
References: <20240202220459.527138-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometimes we want to convert an address in objdump output to
map-relative address to match with a sample data.  Let's add
map__objdump_2rip() for that.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/map.c | 20 ++++++++++++++++++++
 tools/perf/util/map.h |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 54c67cb7ecef..66542864b7b5 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -594,6 +594,26 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
 	return ip + map__reloc(map);
 }
 
+u64 map__objdump_2rip(struct map *map, u64 ip)
+{
+	const struct dso *dso = map__dso(map);
+
+	if (!dso->adjust_symbols)
+		return ip;
+
+	if (dso->rel)
+		return ip + map__pgoff(map);
+
+	/*
+	 * kernel modules also have DSO_TYPE_USER in dso->kernel,
+	 * but all kernel modules are ET_REL, so won't get here.
+	 */
+	if (dso->kernel == DSO_SPACE__USER)
+		return ip - dso->text_offset;
+
+	return map__map_ip(map, ip + map__reloc(map));
+}
+
 bool map__contains_symbol(const struct map *map, const struct symbol *sym)
 {
 	u64 ip = map__unmap_ip(map, sym->start);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 49756716cb13..65e2609fa1b1 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -132,6 +132,9 @@ u64 map__rip_2objdump(struct map *map, u64 rip);
 /* objdump address -> memory address */
 u64 map__objdump_2mem(struct map *map, u64 ip);
 
+/* objdump address -> rip */
+u64 map__objdump_2rip(struct map *map, u64 ip);
+
 struct symbol;
 struct thread;
 
-- 
2.43.0.594.gd9cf4e227d-goog

