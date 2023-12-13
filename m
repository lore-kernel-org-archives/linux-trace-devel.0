Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iza/XTFq"
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE62F2;
	Tue, 12 Dec 2023 16:13:35 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1d350dff621so91945ad.1;
        Tue, 12 Dec 2023 16:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702426415; x=1703031215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkkFWfvjQLCvXur8tZcl1ZlAE8gNAy7zE9mjhobcdGI=;
        b=Iza/XTFqaPFbG0sf6s2K/afH/mNtHb5+/Pl55K9aVdQYxEDHTVvgY0LD6QsWEIjRlI
         KpHlYDxKY4k0w9fLgqxtWhsYLE184MOU9Rx+GvLe29XoWPuvg2Fo+UG5SADOzQerrrg1
         9opd27fNwk4GkDBfoOIcncQYXpI8Y7qRO5RFBTnX5+cup7fxNUnfpk87pMXR+QmHSu+A
         HtI1Hr1R/oxs2jk8e4fj2A3Yur0bTCBcrRfiLIJUK3TOZAgvHfANd//DSkPtcS+gG7Ix
         r8hqNm3M3Yi3K9rEwH4O9Q4mSAh7zLmOcxo7DUuyrDBBBo+Lx42lK/d/dBLpjMTGUmsf
         fzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702426415; x=1703031215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PkkFWfvjQLCvXur8tZcl1ZlAE8gNAy7zE9mjhobcdGI=;
        b=lhwh/fu7NXTgx9sAi/5v2fgEXigRb1hrUV+HOWL7wNrIhlHavpq0rYGCxKM17zH77u
         8tZsvaNyUWxmH/e1jF9mJ2SlLNsVsegjQ8n15L/HJzlQoFmWREN6CaouuKcrtMTeCIuI
         Rnp1G0DlvetB3pNd7KwlxZUyzppda/1dO+vkJri31+lzuVg6X4/AWgBq3J6flyeAEdj/
         gFKVaDv3vGyuaFmRo+K/4BxjdUA6w8iDzjM87g5NrExnrM2rlRno1KG+3Tp8dVR/6gi8
         8YkZjbMcgz6V+e9MlAy+v+HqRZy40+eQF5fIaRhIevDH1gPy4mX8LNSRVVCjrtl9HcG4
         HXzA==
X-Gm-Message-State: AOJu0Yy1SkJb19Vg89H2EMlbiVsO1G7x7VRZ08EBYBel0sdOP3P2l6M1
	YupFn8jFjAZS115jooVV6dQ=
X-Google-Smtp-Source: AGHT+IFcTDro9RYV5lVrmC9QPOmsck94l6Vq6oGMX/nT6RiCpEnyKcb1hYKRm49ENiezN9lOibBrpg==
X-Received: by 2002:a17:902:7ecf:b0:1d3:3c35:81b5 with SMTP id p15-20020a1709027ecf00b001d33c3581b5mr1294421plb.46.1702426415314;
        Tue, 12 Dec 2023 16:13:35 -0800 (PST)
Received: from bangji.corp.google.com ([2620:15c:2c0:5:8251:f360:4316:214e])
        by smtp.gmail.com with ESMTPSA id i11-20020a17090332cb00b001d0ab572458sm9136398plr.121.2023.12.12.16.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 16:13:34 -0800 (PST)
Sender: Namhyung Kim <namhyung@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Stephane Eranian <eranian@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	linux-toolchains@vger.kernel.org,
	linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/17] perf annotate: Factor out evsel__get_arch()
Date: Tue, 12 Dec 2023 16:13:11 -0800
Message-ID: <20231213001323.718046-6-namhyung@kernel.org>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
In-Reply-To: <20231213001323.718046-1-namhyung@kernel.org>
References: <20231213001323.718046-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The evsel__get_arch() is to get architecture info from the environ.
It'll be used by other places later so let's factor it out.

Also add arch__is() to check the arch info by name.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 44 +++++++++++++++++++++++++++-----------
 tools/perf/util/annotate.h |  2 ++
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index c81fa0791918..27b2a9961cd5 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -843,6 +843,11 @@ static struct arch *arch__find(const char *name)
 	return bsearch(name, architectures, nmemb, sizeof(struct arch), arch__key_cmp);
 }
 
+bool arch__is(struct arch *arch, const char *name)
+{
+	return !strcmp(arch->name, name);
+}
+
 static struct annotated_source *annotated_source__new(void)
 {
 	struct annotated_source *src = zalloc(sizeof(*src));
@@ -2378,15 +2383,8 @@ void symbol__calc_percent(struct symbol *sym, struct evsel *evsel)
 	annotation__calc_percent(notes, evsel, symbol__size(sym));
 }
 
-int symbol__annotate(struct map_symbol *ms, struct evsel *evsel,
-		     struct arch **parch)
+static int evsel__get_arch(struct evsel *evsel, struct arch **parch)
 {
-	struct symbol *sym = ms->sym;
-	struct annotation *notes = symbol__annotation(sym);
-	struct annotate_args args = {
-		.evsel		= evsel,
-		.options	= &annotate_opts,
-	};
 	struct perf_env *env = evsel__env(evsel);
 	const char *arch_name = perf_env__arch(env);
 	struct arch *arch;
@@ -2395,23 +2393,43 @@ int symbol__annotate(struct map_symbol *ms, struct evsel *evsel,
 	if (!arch_name)
 		return errno;
 
-	args.arch = arch = arch__find(arch_name);
+	*parch = arch = arch__find(arch_name);
 	if (arch == NULL) {
 		pr_err("%s: unsupported arch %s\n", __func__, arch_name);
 		return ENOTSUP;
 	}
 
-	if (parch)
-		*parch = arch;
-
 	if (arch->init) {
 		err = arch->init(arch, env ? env->cpuid : NULL);
 		if (err) {
-			pr_err("%s: failed to initialize %s arch priv area\n", __func__, arch->name);
+			pr_err("%s: failed to initialize %s arch priv area\n",
+			       __func__, arch->name);
 			return err;
 		}
 	}
+	return 0;
+}
+
+int symbol__annotate(struct map_symbol *ms, struct evsel *evsel,
+		     struct arch **parch)
+{
+	struct symbol *sym = ms->sym;
+	struct annotation *notes = symbol__annotation(sym);
+	struct annotate_args args = {
+		.evsel		= evsel,
+		.options	= &annotate_opts,
+	};
+	struct arch *arch = NULL;
+	int err;
+
+	err = evsel__get_arch(evsel, &arch);
+	if (err < 0)
+		return err;
+
+	if (parch)
+		*parch = arch;
 
+	args.arch = arch;
 	args.ms = *ms;
 	if (annotate_opts.full_addr)
 		notes->start = map__objdump_2mem(ms->map, ms->sym->start);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 589f8aaf0236..2ef7e7dda7bd 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -61,6 +61,8 @@ struct ins_operands {
 
 struct arch;
 
+bool arch__is(struct arch *arch, const char *name);
+
 struct ins_ops {
 	void (*free)(struct ins_operands *ops);
 	int (*parse)(struct arch *arch, struct ins_operands *ops, struct map_symbol *ms);
-- 
2.43.0.472.g3155946c3a-goog

