Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6A6ECB;
	Thu, 12 Oct 2023 03:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJhVsW94"
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FC7D6B;
	Wed, 11 Oct 2023 20:51:49 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-690bd8f89baso426268b3a.2;
        Wed, 11 Oct 2023 20:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697082708; x=1697687508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKck2Vhi5vdIr2Ld7wZJwpnMfvRFO2t6RvphUhl2GmU=;
        b=aJhVsW94p4EMEzWBitzN66LyGAHkhjlH/fFLNb6WrYlQS1fo/9JIfaNXTy7qw542dd
         0bXwYElhfYE1ICHp+uQF3e+UFEnDMyOfoURvSuGT27PT6Wj6sIodf3nxSFYzZAp0bmbS
         VA4ehgPpmQwNUK9ZoH/UUaRt6GZ2RqooRFBT3o6VmR6Py2IR09Cvzw9XEfns8NpIxZOD
         AcjC3cvS8d8sg+fL2cHXb1EIMlkvQzsSaxbJw+pAuN3kT6KIs3cOURcbekY32vzXuMi4
         lRtjv5XwP6Lo2erH5SiL02aTG6HGjX4zoEGai3jhCMOTh/SUk+x9v1pqbi9wmGT4aMW7
         +JiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697082708; x=1697687508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oKck2Vhi5vdIr2Ld7wZJwpnMfvRFO2t6RvphUhl2GmU=;
        b=sbUVnQrahg40eLsuOGrDkXc2fD3vABEI1UJr/O2gDNj4g3ByE2ez1kKWXdjAMtyN83
         94bRbz+swdiV3xJ52bq87aSMb+SEOyf2YBMbA3qC220ZpkLWzjFtuv4JFcWA1sFNMEa1
         ILr7fBbZlib00i1Qj7u/jFBcfGWK4UyXFJAedhWtYOd+G1johj21rz4wzPimTioC/AXY
         8ENGxGNNVj53DjWWqDfuyOnE2VwLl1u8fdJYVK5zs5/5kFq2i27JtjrjbnnZrmw4nWzT
         EtCGt12INQo2A9chWnL+IEdM+wOt0HqDybWcQMZ+pKZS2kWztmXmEFJKVSE9XO2RUkhb
         fEIQ==
X-Gm-Message-State: AOJu0Ywq1uiekOPrpkg5UxD9qUYSLObJtwgm3IL7anS66neb3JqSw4LT
	Dccu/OtOy6WVh8S+z+2ve0U=
X-Google-Smtp-Source: AGHT+IHRs3gHC887q/Hhr+I+GDwkm7wMt+t7h0Y9L9HACBo7w4oB1LkKVftmQUR2Mg6Vk79ZbXDZhg==
X-Received: by 2002:a05:6a20:54a4:b0:159:b7ba:74bd with SMTP id i36-20020a056a2054a400b00159b7ba74bdmr24119644pzk.50.1697082707646;
        Wed, 11 Oct 2023 20:51:47 -0700 (PDT)
Received: from bangji.hsd1.ca.comcast.net ([2601:647:6780:42e0:b1b9:d490:2f5e:be06])
        by smtp.gmail.com with ESMTPSA id w8-20020a170902d70800b001bc18e579aesm711374ply.101.2023.10.11.20.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 20:51:47 -0700 (PDT)
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
Subject: [PATCH 25/48] perf annotate-data: Handle macro fusion on x86
Date: Wed, 11 Oct 2023 20:50:48 -0700
Message-ID: <20231012035111.676789-26-namhyung@kernel.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231012035111.676789-1-namhyung@kernel.org>
References: <20231012035111.676789-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When a sample was come from a conditional branch without a memory
operand, it could be due to a macro fusion with a previous instruction.
So it needs to check the memory operand in the previous one.

This improves the stat like below:

  Annotate data type stats:
  total 294, ok 147 (50.0%), bad 147 (50.0%)
  -----------------------------------------------------------
          30 : no_sym
          32 : no_mem_ops
          71 : no_var
           6 : no_typeinfo
           8 : bad_offset

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 190489df0fb7..b0893d8f2ae3 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -3710,6 +3710,7 @@ struct annotated_data_type *hist_entry__get_data_type(struct hist_entry *he)
 		return NULL;
 	}
 
+retry:
 	istat = annotate_data_stat(&ann_insn_stat, dl->ins.name);
 	if (istat == NULL) {
 		ann_data_stat.no_insn++;
@@ -3726,7 +3727,7 @@ struct annotated_data_type *hist_entry__get_data_type(struct hist_entry *he)
 		if (!op_loc->mem_ref)
 			continue;
 
-		/* Recalculate IP since it can be changed due to LOCK prefix */
+		/* Recalculate IP because of LOCK prefix or insn fusion */
 		ip = ms->sym->start + dl->al.offset;
 
 		mem_type = find_data_type(ms, ip, op_loc->reg, op_loc->offset);
@@ -3745,6 +3746,20 @@ struct annotated_data_type *hist_entry__get_data_type(struct hist_entry *he)
 		return mem_type;
 	}
 
+	/*
+	 * Some instructions can be fused and the actual memory access came
+	 * from the previous instruction.
+	 */
+	if (dl->al.offset > 0) {
+		struct disasm_line *prev_dl;
+
+		prev_dl = list_prev_entry(dl, al.node);
+		if (ins__is_fused(arch, prev_dl->ins.name, dl->ins.name)) {
+			dl = prev_dl;
+			goto retry;
+		}
+	}
+
 	ann_data_stat.no_mem_ops++;
 	istat->bad++;
 	return NULL;
-- 
2.42.0.655.g421f12c284-goog

