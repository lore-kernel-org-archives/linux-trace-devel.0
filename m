Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06D8255E32
	for <linux-trace-devel@vger.kernel.org>; Wed,  9 Apr 2025 11:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744196847; cv=none; b=FuES1mi2PP8SEOlz9UjAQyqzm25nr3+l6owbFs6wKbVrzHHv7KdFgG+gOUHTs+zKKt7arWAIDlOrLl8Udv4tCYN5m54hayh/VRS5A2I8sMXqtqyWtdMN4F/Be5+MHIefqPPnDy6w1RarDo4MLTGrqm+wc0ZoUF6q+fH0QtPIRTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744196847; c=relaxed/simple;
	bh=Ngp+Ygco2D85lN7G9I04R8DAqslRYFSJo1LkCb6FRWw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o6pRkc/G9Cq6sqpQnrpeMu3FiAGeEFT5R/fHzci4+aL2Q7TBkC+HaLg+InDyfR9iti32EDrtKn3O+zgF/wGInsJLYbRWhbN+8SxXCosEyq4YHFXxummzECdUypWanOOJKJmbEDVy1+LoEVJ81oxIwZ59h/i5FNFvZy+D90Tx9Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz; spf=none smtp.mailfrom=malat.biz; dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b=cSAe/pV0; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=malat.biz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=malat.biz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=malat-biz.20230601.gappssmtp.com header.i=@malat-biz.20230601.gappssmtp.com header.b="cSAe/pV0"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac339f53df9so1175021166b.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Apr 2025 04:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=malat-biz.20230601.gappssmtp.com; s=20230601; t=1744196840; x=1744801640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=epkCNLpe4oNH+frAflmZOb/usMSROBTx0rihRso+Xy4=;
        b=cSAe/pV0lK/HWzCup/onyQpJJxdkrMSxfCeUZ4Wx+U9vpMD+5TxbXQEJUsJqlNS90a
         Ltxk/mPnZqKj6OjBmxGYF06sWg8aA5ZWptWcQmcrsHHU/ehu3zJZUxhxapMoyvRUxZR3
         xvl6/Qc3NcTBrFJwJ2fAAldvcMLyxYDXCPtfyNgw/SYO0zuFpzs4/8A0dgnH8+OMbJJU
         MvS7eOmQzK+4uKg6LXY1G1nlS63z8I3qzonnOwEs9YuIotolaAhB3xiQBXJv3oeGuoUo
         FVRckBuebLF2Hd6fXOcIVhTh2EUFtsHPBdSU4s5zEbkFZDlz6+dCGdFzX2MHU1pTusO6
         Y2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744196840; x=1744801640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=epkCNLpe4oNH+frAflmZOb/usMSROBTx0rihRso+Xy4=;
        b=Lbg6hwzZ4RiGrI/Rk2OxaUN/EbMALPmnD14OqyfVaqi0xdPfdhm0epBxradgTyxbdE
         pVhlRUKkur3whyXDvFzRN4NfIkzRyAxa13EENuXoegPK8jA4DvwtG1ns2WtBaqn+Eyws
         ctIvCO6id/CENjJof+lRaKX5RYljlFJs05Of7gDowx2pkgUwh8+h/ZGKXuKxAkda2EVN
         CcgolljKUgqt7NX5iQVEWXD3q5k6o/iarzNE4WAWQRQxF9Ht1kwypLNUVgOytcRFixlR
         j8EdgBqnRTdQQsBAUqn0/rXYYS+0WJ78/1U9ZIsuSjo+aZZxf4nJfvjJzjGxEMLMO6Ci
         2OOg==
X-Gm-Message-State: AOJu0Yyi+uIGgmwCr0E6vi+eiEmz7UKJNaY94RuESCJFScXoLogcRa37
	Zqhvt7g/fEGvaorKB5JUh6hJJOA9hDYEbOhkFOt3cCMBjvWUEMP4wD9nC67WovISDDzdCP+i+XD
	VRQ==
X-Gm-Gg: ASbGncsiokAfb7gACjS1d9430qZTA1kgl+ML9hzAtMM6vn4Z3dtjzsGGwGIROsbrzBW
	wfThcFxXQFEBnf8aRuHeODVEUHUml/hqVVsUyWDavTxhs6Z7qpr0B9o7KZsQflbJkps+6R+yRhC
	jQGOgD6WZTvHzV55+G97xbTkF+NQMemzkl4Hpf2GGxlNLZDFQ2q/LrHK4d2TnyHEhXO9UntASSX
	4deEh3lJInTAp4rcdGrw3v6jPLO1423U+0gXG/vPxa+dH+N3i0pcCZOWqHYDB23Dj1W877/njhe
	vXOk2A8ZTzAUwbeCU8+dEy2HAaQkeOvngeVpwAfcNX8wwjmvxe9rAkg=
X-Google-Smtp-Source: AGHT+IElTyiJ89/16idulavWBxgS2Oa/DUVOrku8H6jUDeUnLEp3jOeuFeKQn81I3OlOmfEFLZ4EdA==
X-Received: by 2002:a17:907:1b09:b0:ac7:e366:1eab with SMTP id a640c23a62f3a-aca9d6f4216mr172898266b.48.1744196839991;
        Wed, 09 Apr 2025 04:07:19 -0700 (PDT)
Received: from localhost.localdomain (snat2.klfree.cz. [81.201.48.25])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-acaa1be9c0dsm79968766b.61.2025.04.09.04.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 04:07:19 -0700 (PDT)
From: Petr Malat <oss@malat.biz>
To: linux-trace-devel@vger.kernel.org
Cc: Petr Malat <oss@malat.biz>
Subject: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap during print
Date: Wed,  9 Apr 2025 13:07:05 +0200
Message-Id: <20250409110705.437321-1-oss@malat.biz>
X-Mailer: git-send-email 2.39.5
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
functions. Support them in the print format string.

Signed-off-by: Petr Malat <oss@malat.biz>
---
 plugins/Makefile     |  1 +
 plugins/plugin_net.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)
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
index 0000000..c5eddb5
--- /dev/null
+++ b/plugins/plugin_net.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: LGPL-2.1
+#include <stdint.h>
+
+#include "event-parse.h"
+#include "trace-seq.h"
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
+				    process_builtin_bswap16,
+				    TEP_FUNC_ARG_INT,
+				    "__builtin_bswap16",
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
+				    "__builtin_bswap64",
+				    TEP_FUNC_ARG_LONG,
+				    TEP_FUNC_ARG_VOID);
+	return 0;
+}
+
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
+{
+	tep_unregister_print_function(tep, process_builtin_bswap16,
+				      "__builtin_bswap16");
+	tep_unregister_print_function(tep, process_builtin_bswap32,
+				      "__builtin_bswap32");
+	tep_unregister_print_function(tep, process_builtin_bswap64,
+				      "__builtin_bswap64");
+}
-- 
2.39.5

