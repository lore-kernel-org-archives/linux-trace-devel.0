Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2794819D8A8
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594912; cv=none; b=GcXXpTfGKIk1G/YE3tDCGcDyjRkBecBkAOz2XR90CyN9YXaX2uZXOuJnyUtTpdKgaipowjoEm3/qj8eMmtIj6KfJ3A3cCbikcyMNBXeioCa41OC2GWspzjHrjCL4gBrnpkEPCeeC78dYjal6zZlwxyrWZm/F1ZjRs57TYiFjUuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594912; c=relaxed/simple;
	bh=kn9qEAQZiOOlOT69CEPK5wKUowJJCq2NDZLDy8djnFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzSYUf1SZcq5PdNyAvkNhXnZdwK0mQn4nHPKQw9Zz7CPPwSsSyjvRmFhwTbUmkarBXcALJCbG81trPUx/2dwXRbSNXEBOlzg8eLIJWANr7C0KzSCsh/sHgpNAoCuqGdY7ETDJcUgeHO/MSQBh4O6JVXMTCOYKoMqC02f+XcgzLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tg3ikd5r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tg3ikd5r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L0csOYl5mrYAN1++D7VAQRUoLPDVs1VTI5Cj0jS8D+s=;
	b=Tg3ikd5rlX0Ymq0wtCGLerYNXsNVdD3K/HLMvDn95aroWXp4T+JBKGsnZDQuqNerAtfQJ6
	YRvBAKhRIX4vG8EO296/xbgBozhTERCigNtvgvgB9dWRBLhEi7sl7HwqwPnK3xZ9pyMS1q
	N2nufFX6ClmgedAmn7/zDq0x5QDAaxY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-FM_zmFORNhWh4M5xAwm3ZA-1; Wed, 05 Jun 2024 09:41:47 -0400
X-MC-Unique: FM_zmFORNhWh4M5xAwm3ZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C96B28007A1;
	Wed,  5 Jun 2024 13:41:46 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id F14D137D0;
	Wed,  5 Jun 2024 13:41:44 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:44 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 13/38] trace-cmd record: prevent a memory leak in show_error()
Date: Wed,  5 Jun 2024 15:40:28 +0200
Message-ID: <20240605134054.2626953-14-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

In show_error() the pointer p is used for several functions. At some
point it is used to contain the error log file. It's not freed before
being replaced by the result of read_file(path), which is not freed
either. Free p in both case.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f05a58d1..3e29f922 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2364,13 +2364,16 @@ static void show_error(const char *file, const char *type)
 			goto read_file;
 		}
 		read_error_log(p);
+		free(p);
 		goto out;
 	}
 
  read_file:
 	p = read_file(path);
-	if (p)
+	if (p) {
 		printf("%s", p);
+		free(p);
+	}
 
  out:
 	printf("Failed %s of %s\n", type, file);
-- 
2.44.0

