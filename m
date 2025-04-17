Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1742512D7
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 14:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744900907; cv=none; b=RX4C1eOrnjpm34Y0OIEEGwbYLVs9815eU/mKUrW30HlVruaemRGSnxjZpfQdMBeIUW/51GynUfbmAWmgBzqIVFLwUuvQtwy66bWNW8O9Al/4ic6Kdw4hbhaHnqfvdj7Fsf7hKAIkVkxT0CsQWuKve1q2JYvFt78V92k8Zn45YdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744900907; c=relaxed/simple;
	bh=7IbvMJfkXP28Ou6RDmyjMYM1TTfZUqP152dazb5zHZg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NuR2gEHDQ5IYXZ4jcgfueY6b5O0pWWC+Eu7jmtH2eu6oT/LG5/fzD6jdPJLmH3nExqtGYCA2nEem8Sd4Hd7p2FlVUO+2shhLG1FSVfhgWVTn44JA8oeumSasmrj5rpsKf4/dvK734qkLme638r1f+O64vAdxmmEhKdek/RTj4Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz; spf=none smtp.mailfrom=malat.biz; dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b=fxpSi+uc; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=malat.biz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b="fxpSi+uc"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2c663a3daso153935066b.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 07:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20230601.gappssmtp.com; s=20230601; t=1744900904; x=1745505704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teWpwPC7H1VVn6j/5G/4dGHFIuNfDzkuePibjdUXj4M=;
        b=fxpSi+ucyCNbULt8DLp+TitRJmTIylOlGmSMYcOZddnZUKkCCpR8sdnvWyyfxrqzF+
         Yqt1n9xohlnAWl6uI1UMe4jOe9irMDkQ6efRI4kEtL6FDz054r4eFw729Obu2X1JNXWZ
         bYiUhnYB5qgmM5XORaCtW7Jh8eqOAPw7DwI1+HZEwc7Tc5mTLzicWXWioFiQd8cWrX6d
         lIEjvIp7gyGhXn/jNm7PX6QySEmHkl2MgBWYV/r6pn+TvmLWJuNoz+UxrTASWLBzmD2Q
         9Y4sXqusFOwfeEQ/dvFfvoUz7lDWoDBmwQbhMyqrVmPZgUmBnKrEjUlrUA4a1A2Al8V9
         URmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744900904; x=1745505704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=teWpwPC7H1VVn6j/5G/4dGHFIuNfDzkuePibjdUXj4M=;
        b=tOi+U23ntBAhPvRpT/1mPVozUOGSN2tKBFuwWsfrGRBqn2xsse9nxgG061v2Hgh47W
         TVx+BqpTNVbzB2uoBiBsPuGVKVxHZE1/IlrfDggeEHtj2vPeL3XaGJJ461yk5REDGl0r
         WxaiqK/W2t9nl7jpJr+YRJ6sU552oCIfmxbc18lIZ71K94ffMQN6jmTWFfBOocCvniAt
         YBis8qJeVfCErc5YlAU8tPDRFJULxlN91CxPKRbEVyA7bch/dvsvNL55FL/+leNNq4uP
         5Lq5Jiw7Qx8uo5R9QiMabwonGARi4Ba5VQ+h1vJvLI9ggu3GsEKzC0Sgk0iTqO7jMUDI
         s2XQ==
X-Gm-Message-State: AOJu0YymN+U+AsVYY4UIhOTZADjZeWYRkZ/x7Ct2qsuVFsnuGLMu5ZxB
	YpKyjskVgWdQ1looNYHqMHh66Uw6xC0SqMQF+5gBqPWxs1ljiGqd29Ve5jwUt5ahCGwp1wIw7PR
	12w==
X-Gm-Gg: ASbGncu6Vshrzqip/pxPU6hDh316yvNQf5YFpxlHINMwf972J5C9c/jVYD/bJjT+I4F
	hGLps/HfG1vmGayYhfvARVE6R296A1DuFu4kCzLR3A/Z7NUdzWfvy4OERQUK8Hyer1jirsN+tc2
	HDNJiPAx6UL/0qjksb0cDmkXAblVg5KboqFF9g27Dal2jzDK4/Z+AOEiUHPxkyAOXjeI1m4ABvF
	ybSINmu6hvNkSaRWmoJtqvFY+wKCGdBpB8aPM3ni+XsiwfCqbHJqZaqpGzIiVyuyPt4lXj61J6m
	DA0XHTIVZBfOXrqW9eAKPsgETsQBBe0TCJyF
X-Google-Smtp-Source: AGHT+IERhacRL2jI4Auu7UxWUcgrvkeBILcTlyAPZdN25LBluUv0QfQpomoBhPw1ULRYF2fr4dJZrg==
X-Received: by 2002:a17:907:c1c:b0:aca:dd0d:470e with SMTP id a640c23a62f3a-acb42a2f8f4mr551019366b.24.1744900903756;
        Thu, 17 Apr 2025 07:41:43 -0700 (PDT)
Received: from ntb.lan ([193.86.118.65])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-acb6eefcf4fsm2191766b.109.2025.04.17.07.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 07:41:43 -0700 (PDT)
From: Petr Malat <oss@malat.biz>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	Petr Malat <oss@malat.biz>
Subject: [PATCH v2] libtraceevent plugins: Add plugin_net to handle byte swap during print
Date: Thu, 17 Apr 2025 16:41:27 +0200
Message-Id: <20250417144126.702609-1-oss@malat.biz>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250417074900.15044cc2@gandalf.local.home>
References: <20250417074900.15044cc2@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Traced data my be stored in the network order and transformed to the
host order at print time by ntohs() or similar functions. These
functions end up being implemented by one of __builtin_bswapXX()
or by a combination of __builtin_constant_p() and __fswapXX().
Support them in the print format string.

The __builtin_constant_p() is used in conditionals, which have an
optimized version for constant argument like this:
  __builtin_constant_p(X) ? constant_expression(X) : func(X)
Always assume __builtin_constant_p() is false, as the false branch
should be generic and work even with constant.

Signed-off-by: Petr Malat <oss@malat.biz>
---
 plugins/Makefile     |  1 +
 plugins/plugin_net.c | 94 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)
 create mode 100644 plugins/plugin_net.c

diff --git a/plugins/Makefile b/plugins/Makefile
index 4c8cb17..c07315e 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -91,6 +91,7 @@ PLUGINS += plugin_hrtimer.so
 PLUGINS += plugin_kmem.so
 PLUGINS += plugin_kvm.so
 PLUGINS += plugin_mac80211.so
+PLUGINS += plugin_net.so
 PLUGINS += plugin_sched_switch.so
 PLUGINS += plugin_function.so
 PLUGINS += plugin_futex.so
diff --git a/plugins/plugin_net.c b/plugins/plugin_net.c
new file mode 100644
index 0000000..4aae7fb
--- /dev/null
+++ b/plugins/plugin_net.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: LGPL-2.1
+#include <stdint.h>
+
+#include "event-parse.h"
+#include "trace-seq.h"
+
+static unsigned long long
+process_builtin_constant_p(struct trace_seq *s, unsigned long long *args)
+{
+	return 0;
+}
+
+static unsigned long long
+process_builtin_bswap16(struct trace_seq *s, unsigned long long *args)
+{
+	return __builtin_bswap16((uint16_t)args[0]);
+}
+
+static unsigned long long
+process_builtin_bswap32(struct trace_seq *s, unsigned long long *args)
+{
+	return __builtin_bswap32((uint32_t)args[0]);
+}
+
+static unsigned long long
+process_builtin_bswap64(struct trace_seq *s, unsigned long long *args)
+{
+	return __builtin_bswap64(args[0]);
+}
+
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
+{
+	tep_register_print_function(tep,
+				    process_builtin_constant_p,
+				    TEP_FUNC_ARG_INT,
+				    "__builtin_constant_p",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
+	tep_register_print_function(tep,
+				    process_builtin_bswap16,
+				    TEP_FUNC_ARG_INT,
+				    "__fswab16",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
+	tep_register_print_function(tep,
+				    process_builtin_bswap16,
+				    TEP_FUNC_ARG_INT,
+				    "__builtin_bswap16",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
+	tep_register_print_function(tep,
+				    process_builtin_bswap32,
+				    TEP_FUNC_ARG_INT,
+				    "__fswab32",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
+	tep_register_print_function(tep,
+				    process_builtin_bswap32,
+				    TEP_FUNC_ARG_INT,
+				    "__builtin_bswap32",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
+	tep_register_print_function(tep,
+				    process_builtin_bswap64,
+				    TEP_FUNC_ARG_LONG,
+				    "__fswab64",
+				    TEP_FUNC_ARG_LONG,
+				    TEP_FUNC_ARG_VOID);
+	tep_register_print_function(tep,
+				    process_builtin_bswap64,
+				    TEP_FUNC_ARG_LONG,
+				    "__builtin_bswap64",
+				    TEP_FUNC_ARG_LONG,
+				    TEP_FUNC_ARG_VOID);
+	return 0;
+}
+
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
+{
+	tep_unregister_print_function(tep, process_builtin_constant_p,
+				      "__builtin_constant_p");
+	tep_unregister_print_function(tep, process_builtin_bswap16,
+				      "__fswab16");
+	tep_unregister_print_function(tep, process_builtin_bswap16,
+				      "__builtin_bswap16");
+	tep_unregister_print_function(tep, process_builtin_bswap32,
+				      "__fswab32");
+	tep_unregister_print_function(tep, process_builtin_bswap32,
+				      "__builtin_bswap32");
+	tep_unregister_print_function(tep, process_builtin_bswap64,
+				      "__fswab64");
+	tep_unregister_print_function(tep, process_builtin_bswap64,
+				      "__builtin_bswap64");
+}
-- 
2.39.5

