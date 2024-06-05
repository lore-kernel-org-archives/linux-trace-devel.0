Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB261957E7
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594905; cv=none; b=dgD0reupFa1LztvUEe5N1GIqRKuyzW7/GxtGp5IcHa37swkKmHU0ZoKkUKlFpEglvMUUcHiRbGCON7aeqrj9Cb4KJpfm4Dx7/1U1FM9eVMPS3+1qpntzTAVtCAENZV56vCTSRPKuNxy3o02x0l9KMPRPuZ1poBHMc1YYa/Q2ZxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594905; c=relaxed/simple;
	bh=0Ce7jOE5E/w4OCrMIZ6dOEH62F/LTxWBFmZY7fhjQRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prKgkVetziVb3vs5hz6zQuxD8R1zkwDoeqt2/9abDt1izhV1wA2SvD3yHqNtI8UI0N6JBbs05/fUhesPF+mihxaY2QO+RsbRucmhQ1TxKCL02OUCJokH1m5y/IPUnWI8JVglT0dPbBRO7ASt45zhc24EgEYEXI+5zXVAy+P3ws8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R2r6pzGi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R2r6pzGi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=obTzUGN5FVWNsyENElKmTg5DcPTYLmPR4sdzondgsNE=;
	b=R2r6pzGij4QeDe0C7Qd40J7W+Lnm2XDmhWEpdu7k+e7b17fi69S3M2gwiadkLrTyX0HJ1c
	OsYMPmUi6XB3m0OIdy2zaLd/n2vmavrOCzI44mi1CzBIILeM9GhdV9D0ug6UuqtNdK6RwC
	HpFW8T7CJABLzWqtlnjKk1JX3AZWg5Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-xiiSjevdPxKYogKBmdoniA-1; Wed,
 05 Jun 2024 09:41:41 -0400
X-MC-Unique: xiiSjevdPxKYogKBmdoniA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD1DD1955D68;
	Wed,  5 Jun 2024 13:41:40 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 77DA619560A7;
	Wed,  5 Jun 2024 13:41:38 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:37 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 11/38] trace-cmd record: prevent possible memory coruption in get_pid_addr_maps()
Date: Wed,  5 Jun 2024 15:40:26 +0200
Message-ID: <20240605134054.2626953-12-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

If strdup() fails the error path access original address of
maps->lib_maps after it has been dereferenced. Make sure that
maps->lib_maps contains the up-to-date pointer before calling calling
a function that could fail.

This was flagged as ressource leak (CWE-772) because map isn't freed
in that scenario, but there is something worse going on that the
static analysis missed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 91cc90d4..f05a58d1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1230,12 +1230,12 @@ static int get_pid_addr_maps(struct buffer_instance *instance, int pid)
 				      (maps->nr_lib_maps + 1) * sizeof(*map));
 			if (!map)
 				goto out_fail;
+			maps->lib_maps = map;
 			map[maps->nr_lib_maps].end = end;
 			map[maps->nr_lib_maps].start = begin;
 			map[maps->nr_lib_maps].lib_name = strdup(mapname);
 			if (!map[maps->nr_lib_maps].lib_name)
 				goto out_fail;
-			maps->lib_maps = map;
 			maps->nr_lib_maps++;
 		}
 	}
-- 
2.44.0

