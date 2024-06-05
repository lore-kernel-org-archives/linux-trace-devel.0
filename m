Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E386188CAD
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594932; cv=none; b=gNhp3bGfSAVxFl4i18P2Z24AAknhfR/GNA5C4QFPk5vTujSY0r7r0iTBvoVSKQxstGlih/7UCMlTFVf3e5WVbJtsgNIsCKh4wmBNE3fnKQaWowGSxeaXlTX5HPZW5iUDPjk35juPaR+2nDAyOX9M5L85ylvF4qkQDKOFW7J3ZZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594932; c=relaxed/simple;
	bh=+TlN1phKIevAkUlymuoC5IcWe8f9t7XNHO9e1cNtrB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8GEBsXqK1I+sbVDLl46hrf7WN+bXl2owmHN1s+YFMygpqG/TfaeuDh7kVKWpMNp21/v8X5ZX2stLeiHaaljxqst8VsYgUqjkxi2w95tcm62DOvmhcHhd/SkOcEITCsHupIPFsEWlFn24lpl0CwUHlK4y3oLyCrpDVsAtFB3IEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ds//Ew7h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ds//Ew7h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SWiU6Ud80ekGOMRX4VebbVhP0Q+11kyUksdo6eZk1Ek=;
	b=Ds//Ew7hlE9MtIbK6C5ycMljmdD0NWenasxXaFkJ+4lPPlUT8RNVy5FdnzGsz+39ONe+2Z
	ZZJ9iRB8PQmSKINJg64MVRtqu7O7/OC5F8l6RmPstvvDWHhTziTKtDBwH3jPczHCYO0RGF
	8IqbZ7HaKncKelJdOXfUxmfWEcFBpfA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-B2zUFIrcNLeUkinfBaK7qA-1; Wed,
 05 Jun 2024 09:42:08 -0400
X-MC-Unique: B2zUFIrcNLeUkinfBaK7qA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E82A61955D79;
	Wed,  5 Jun 2024 13:42:07 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 68F9C300061C;
	Wed,  5 Jun 2024 13:42:05 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:03 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 19/38] trace-cmd record: prevent memory leak in add_all_instances()
Date: Wed,  5 Jun 2024 15:40:34 +0200
Message-ID: <20240605134054.2626953-20-jmarchan@redhat.com>
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

In __add_all_instances(), name is allocated by strdup(dent->d_name)
but is never freed. Anyway, the content of *name is copied in
append_file() and allocate_instance(), so it didn't need to be
strduped to begin with.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c4d43469..a9e5e64d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -422,7 +422,7 @@ static int __add_all_instances(const char *tracing_dir)
 	}
 
 	while ((dent = readdir(dir))) {
-		const char *name = strdup(dent->d_name);
+		const char *name = dent->d_name;
 		char *instance_path;
 		struct buffer_instance *instance;
 
-- 
2.44.0

