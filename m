Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FDB195FF4
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594888; cv=none; b=a0s6sdg2tGg1fFbatqMCbmp+XzvhVVlWI4l4khxFgTwM/gsjNkF7Vi+tyGsY/2zJYDbkdCSTQ1tEaAIAhLPhhm/vcv7i7ifxaLFm+QS1XJuQVIzxEK6c/XKqpGiKJd3ANTOIqXxWxQiEyHV1O3wTlp5RQ9dHZQHaKt1xc2rKY7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594888; c=relaxed/simple;
	bh=fVirk2G677fvNtEnHPSObvgw1qogj4SaT7CUBGD9/zQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmotf8nJ+kFmFF7a77kLS3Xp2kr2TMjJCyOMSvD+94TFduV0vun0Ij16TClG6c9Ox2MOwB33LpeQ6xrNiNnmUietdMoEEl6IEcQjgnIiMyk5sphrNUUcaU60ELepKAr01oWUNm/YKcMXLMkMB9SusMmqAo2wllfKXRkE8K4M/ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZMm84IFp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMm84IFp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F00/N84Ys+qgsusfhdL0T7CRVc7B3PCgPFwgJ8bdPNc=;
	b=ZMm84IFpr6Fth+LMCDQqX0Ehp4kCeLZpneEsL2XmNh/CM2vmc2Lop0/tymGzIMm/0WH6je
	lJgE+sK2sI8t5H7bWOI3cP063CrUk0F9dAYSxSwA9MjuhldIUzBkaNe3qNHstIklCU1Fvj
	GwpWINtyFqqpxOEo4k8T4m6t5/TAojc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-PZ2qfUHQPACwa33R9jVzYg-1; Wed,
 05 Jun 2024 09:41:24 -0400
X-MC-Unique: PZ2qfUHQPACwa33R9jVzYg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95BE21955D78;
	Wed,  5 Jun 2024 13:41:23 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2D30C1955F79;
	Wed,  5 Jun 2024 13:41:20 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:19 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 06/38] trace-cmd lib: prevent a memory leak in handle_options()
Date: Wed,  5 Jun 2024 15:40:21 +0200
Message-ID: <20240605134054.2626953-7-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Free buf in the error path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-input.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ce4ecf43..2cf0d1c1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4030,7 +4030,7 @@ static int handle_options(struct tracecmd_input *handle)
 		}
 		ret = do_read_check(handle, buf, size);
 		if (ret)
-			goto out;
+			goto out_free;
 
 		switch (option) {
 		case TRACECMD_OPTION_DATE:
@@ -4084,7 +4084,7 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				goto out;
+				goto out_free;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
@@ -4093,7 +4093,7 @@ static int handle_options(struct tracecmd_input *handle)
 					   handle->cpustats_size + size + 1);
 			if (!cpustats) {
 				ret = -ENOMEM;
-				goto out;
+				goto out_free;
 			}
 			memcpy(cpustats + handle->cpustats_size, buf, size);
 			handle->cpustats_size += size;
@@ -4104,7 +4104,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				goto out;
+				goto out_free;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			tracecmd_parse_trace_clock(handle, buf, size);
@@ -4183,6 +4183,8 @@ static int handle_options(struct tracecmd_input *handle)
 
 	ret = 0;
 
+out_free:
+	free(buf);
 out:
 	if (compress)
 		in_uncompress_reset(handle);
-- 
2.44.0

