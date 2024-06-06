Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30357196431
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688334; cv=none; b=I1QvA22qLNCBCHUhpDbIs1W1RKHhAsyE10DWXgyxSjbkCEp0IZ1/vTvXqx7fNEHZX3T0Y5uXAxVM1TO7TBwsZ533zBolZCt+PRtgaGRoR4H40cpZg9rCPVQAmK438+Qur8/hB2xHgIR7cBODkR6U0o+d/EXr5N6PXeIKxfRcFAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688334; c=relaxed/simple;
	bh=18AzkRgaAke3cBnUqay5+gNFxHqRxfLKs8mb98pxjfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAe7RT6U5+Wil0cQaPXLfLCnxoSpMbTA8WYmXi/+RfTn5H5J1q2S7o8Leu+926UArXkC8P3AuNgje0NoYMoZaog1lg0cmCNft7LLZoG8KfUpmhYjbPT7o5kvj09iBmG4FPL/xNzX9gE6ty/SdWmnq14aiPVa6FnTgklL1cuAKcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vfsnpf6o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vfsnpf6o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPLw7DWy9dG19j+4ii7z3zh95dwYvNfHg9GrffDdtag=;
	b=Vfsnpf6o1bveh/QdLJpprFAaD+U6+1PLn/WLgFyi5y8lz2FueX1DfxmeBEkyrzb0FWOR9f
	m0Kp62W5uj+qIWHVV2C1d2wXqclp2qM0Z/UN4AOemXFAL/MQkZ9xaXYD2ia3YAgZ0RN1o0
	FWMGKb+3PFqAdjL+jShM7/DFBDniH1A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-IG-DJejSMLizfjVhSEfogw-1; Thu,
 06 Jun 2024 11:38:49 -0400
X-MC-Unique: IG-DJejSMLizfjVhSEfogw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A89C19344B7;
	Thu,  6 Jun 2024 15:38:49 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id DFCDF1955F4B;
	Thu,  6 Jun 2024 15:38:46 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:45 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 05/15] libtracefs: prevent memory leak in tracefs_event_systems()
Date: Thu,  6 Jun 2024 17:38:19 +0200
Message-ID: <20240606153830.2666120-6-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

If an error is encountered in the loop, enable and sys might not get
freed. Move the calls to free() before possibly exiting the loop.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-events.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 1b1693c..906dbe8 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -854,12 +854,12 @@ char **tracefs_event_systems(const char *tracing_dir)
 		enable = trace_append_file(sys, "enable");
 
 		ret = stat(enable, &st);
+		free(enable);
+		free(sys);
 		if (ret >= 0) {
 			if (add_list_string(&systems, name) < 0)
 				goto out_free;
 		}
-		free(enable);
-		free(sys);
 	}
 
 	closedir(dir);
-- 
2.44.0

