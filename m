Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35231399354
	for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2026 07:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776067138; cv=none; b=RY/CGFC3WU0P3vRdrPcAVroyinojXMnmS83hGJVZOiqc88Wsf0C3JMkM4yB+kI9N8E8SuQqp7O4E1e3IEUXtRx8HoCtzopuym1cxFrtC7FWAaSszUiBsPtoEZa31IN1mygCgiN/kmgf22NHySzwchMoKfb/3eEnyKEwCP4VI7YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776067138; c=relaxed/simple;
	bh=okws4UjvfhK3kr6/N39qZjRHb/6fplnyks8XQacNlLo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f/sMlOQGJ4zX286Bs9si8ileOQkWYZ0ho3F8fbPrp7bzlhrACM5z6zpV0nU//Z9+MOdoMlHwmc3y8Wrfi0bx0sg1LzDsphsVpPDNTrdGYX6g1wtJ5N9Nmqc26dg0NkhasDG3MYgB5FfBUo4cB4yWSwmTcbHBLSLh1meA8y4FqLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VU/aPWIs; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VU/aPWIs"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b6b0500e06so7470279eec.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2026 00:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776067136; x=1776671936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JJk6Zxqkq2OHYbmMgnbvksnaOF6Y7VYH+p2ASP/xX0U=;
        b=VU/aPWIs6PRayHmYX38UgDujYDV1EL5NntKr/+Ar95b/d2MIF0qSrm3b6EZbgBm2Ja
         W4hA0x2Tc3PTXCZQ+g0I47hMlFxkzVLNracE0A/sGwZvIIiL5+YfubLYIL9Ts8QNt/cw
         xlBByzA5ZQcxsELyGmnE+Zj+UENauJMfArrPWB1S/PuNc4yfqguudeMj4Cv+sab1M0jU
         AZKIAyuLG4y8uipbYjmcWsuHbfW30XZD1//30IafZu8q3shpCIO0WOcYc52vGpN/Qw3w
         QfsVn4v2cbTa+h51qRXGWbUtVW2mT91qjRY+OvzUNVOcQa6rTz/5gOfRY1H7NfD5/xQq
         Bo8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776067136; x=1776671936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJk6Zxqkq2OHYbmMgnbvksnaOF6Y7VYH+p2ASP/xX0U=;
        b=iRvx/ZmSDf9QtNrsthR5Pw9YDXNmzbPnUvs9Lp2kg0QtMN9ivn7Y2B94tttlN2axpv
         S86lqSp6d3eMP3rZNo9Ld68oYpZjtW91njRMvpvEamuoFHZVY44lXpzRVjhgiha/OXvu
         zDGepIcUBaX4Mux8JlOahTP8S1fbjIdtYT7CrDSZR1UqYyfXyF3tH09cz7Xj8Sgr/E/+
         n7P94sa1pGNvNlUma7jE1k1zeH1u/zVcyffpByPfwiEwF/O+u7bHmrgcYVYPyoud6qSF
         sk877IgDTDX/9veSaLqpKrkb+FKcy6UWkmbJFbOv6Rf0GWIu/BYnjkjmpLVvWmqIDCf0
         xeKw==
X-Gm-Message-State: AOJu0Yx5OlZEg9QXqfdyq0p4e6+9zGrtg12vENIsz0Iz5ZZ2GjRwCNTJ
	ag2TDh/0ljFW67uKAmwjpVATeIs6NP83KBn+nE7uRjs+BPbiq64YmHVLvZCFtw==
X-Gm-Gg: AeBDiesvTXiax+yLlaBp6YX4N1SfaNY4FMxmgKhT7iHW9nzqVUQ1rpjmPWEiMDzdh2q
	lyuhuS2IXqj0BmmJ7Ajubj0Az1kLlCpTCNZlzT2DfXIf3WNzZsY958839V+pub3/CTGHoC7W/K8
	44oI+y8N9ot/2tO092cYuNHKRYNbsLmPgfIfmKGEcSoMf61dDaQbDSfDBqsIkSbp7dJtmRVMkzP
	b/xEUmXAxHTrauSvn7X1beM0DkHLDfdMIKoSMvQpzuuKViIMNXoQ8o8qI3U+poa9NYCFLSJhliB
	2Bxy9hmdRIPEK3FL8PFhSaIQIeQx+pam82vNc9GvXbKQ3wEYmJO1LCRNzcngvDXMQzW+A9az9TH
	WfQ/fxwwhfuMfB23h8dNOqJ/A7i6FLaF3zqMotPpdq/iucX4VSFn0M2PFYdXNMMqHRnTMjiWtqh
	KV5J99xHegy9Zce8b8YIomqSFC3vh89pQHevPJgYE2aELD4VVAGjYU+cE=
X-Received: by 2002:a05:7301:6788:b0:2d5:3a24:1507 with SMTP id 5a478bee46e88-2d5873b2d13mr6315984eec.7.1776067132224;
        Mon, 13 Apr 2026 00:58:52 -0700 (PDT)
Received: from 59989e37b1d1.cs.ucr.edu (colossus.cs.ucr.edu. [169.235.26.233])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d562db6ac8sm15400824eec.26.2026.04.13.00.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:58:51 -0700 (PDT)
From: Zhengchuan Liang <zcliangcn@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: zzhan461@ucr.edu
Subject: [PATCH] trace-cmd library: Fix virtual memory leak in tracecmd_close()
Date: Mon, 13 Apr 2026 00:58:46 -0700
Message-ID: <20260413075846.1142967-1-zcliangcn@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tracecmd_close() only released the current cpu page and then freed the
remaining page_map objects without unmapping them. As a result, cached
pages and their mmap()ed ranges could survive handle teardown and leak
virtual memory.

Release all cached cpu_data->pages[] entries with __free_page() and
munmap any remaining page_map mappings before freeing them.

Reported-by: Zhao Zhang <zzhan461@ucr.edu>
Co-developed-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Zhao Zhang <zzhan461@ucr.edu>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
---
 lib/trace-cmd/trace-input.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0fa9d956..8e30a8d3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5237,9 +5237,15 @@ void tracecmd_close(struct tracecmd_input *handle)
 	for (cpu = 0; cpu < handle->cpus; cpu++) {
 		/* The tracecmd_peek_data may have cached a record */
 		free_next(handle, cpu);
-		free_page(handle, cpu);
 		if (handle->cpu_data) {
 			cpu_data = &handle->cpu_data[cpu];
+			if (cpu_data->pages) {
+				for (i = 0; i < cpu_data->nr_pages; i++) {
+					if (cpu_data->pages[i])
+						__free_page(handle, cpu_data->pages[i]);
+				}
+			}
+			cpu_data->page = NULL;
 			if (cpu_data->kbuf) {
 				kbuffer_free(cpu_data->kbuf);
 				if (cpu_data->page_map)
@@ -5265,6 +5271,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 			}
 			free(cpu_data->compress.chunks);
 			list_for_each_entry_safe(page_map, n, &cpu_data->page_maps, list) {
+				munmap(page_map->map, page_map->size);
 				list_del(&page_map->list);
 				free(page_map);
 			}
-- 
2.34.1

