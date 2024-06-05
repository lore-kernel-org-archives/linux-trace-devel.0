Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D73F195FF5
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594893; cv=none; b=imusWoxhZIND0d+haPvDDM59YUJ6L2ASMZKorPVGyBftWBvQLl1r2exDVGdxIs8YtPNtqt61GvVM3XTIRTHqf3gRGJqK6/mx6TRAinPQvLd12fhmDdt9ytAtstWdQyVgGAwv9kjdmpzColmU8vq2Ig+Hl3DHchG6rW+hnp/RoYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594893; c=relaxed/simple;
	bh=5ObqETasSDT5kuUx+YlUHYSDYpGmx2dD7zc3CXEXmxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNsBQUt1YU5e14NDunwQLUgRZWM/ImS5NujV5sA3aeICYTZiqUT8zhvqDD9ytlrQ+iRHhUQRUFjLbs2v7K8pRBssvroi+jQ9Jw1FuOToZu+CCDdMaMqHyrGnOdAp4VNSXMDn68YMeG/yTWfQBPEKCN30PZ/66ugTIKtFjVk+QIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PtdVMFcV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PtdVMFcV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YAQZhfOHny/csUEwAv3oEvGMIpVzggTsqPOS8ncjOns=;
	b=PtdVMFcV1LEXoWvpaNuq6xloq7WOSO2/7LbWZc3ChjzpuV1S6PbU2puItu40riete7pFIp
	QDrTzABSwYnL5ZiNNlrPO0DK9nkNBztbqmzMYVct+0qQvQB20pl95XYYqu3uZu9tp5UEj5
	rMgEEMXVNzx0XaWvFKdmT/hHWgoXA5c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-519-0pZfJ11NOMGsyWYxnOIxHA-1; Wed,
 05 Jun 2024 09:41:28 -0400
X-MC-Unique: 0pZfJ11NOMGsyWYxnOIxHA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C107419541A8;
	Wed,  5 Jun 2024 13:41:27 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5DBDD300060C;
	Wed,  5 Jun 2024 13:41:25 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:23 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 07/38] trace-cmd lib: prevent a memory leak in regex_event_buf()
Date: Wed,  5 Jun 2024 15:40:22 +0200
Message-ID: <20240605134054.2626953-8-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Free buf before exiting if strtok fails.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2cf0d1c1..3284dbd4 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -666,6 +666,7 @@ static int regex_event_buf(const char *file, int size, regex_t *epreg)
 	line = strtok(buf, "\n");
 	if (!line) {
 		tracecmd_warning("No newline found in '%s'", buf);
+		free(buf);
 		return 0;
 	}
 	/* skip name if it is there */
-- 
2.44.0

