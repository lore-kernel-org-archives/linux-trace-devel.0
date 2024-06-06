Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E516B196C72
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688327; cv=none; b=rN8dJwtzXBlEBM+qdnCdaZc079OtALunZLwiWirdcjT/mIQ6gYoljJbufZzuJMTJqMHv5fygC7x/xFdfupf2T449w3XA7/YeLJYq2vIhD8yAMLHJ5JVxZ1LjPOkox0Vnilaym0G3oykD39uX+xdQr25unTReOcckoE3+IwvYaoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688327; c=relaxed/simple;
	bh=++fBaxswMezW4ifKm7jt7ksGc+f5fR3mMxP7agOyqyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shf68QQ5YI718vklUbDjwzi4llY+lMIc8dpEJfUzt9YOxfPt6nSLfgmLqsQkLgY8qBZUkfqzHl+Oxo5A4VnN6+NsHtxtYe0z+5zCOz3ArgVGA2Jh7iW5hEOI9+wqSRybSZL1Vrnv0KAFISTjL0CTCJZG8Mimjxpp2FH/iKTnUgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VtN/3tkj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtN/3tkj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FpGU0sBNWte/Y1Z9ColYRXl6cataNb8y3taFahUFRdU=;
	b=VtN/3tkjUG/c73PSTSLE2cO4TcnvMKxhYhEZuis8Bvc40fIbACg7PKmabAQlNtSjj0rNnG
	ow6Jrg0GrqO0HNq5tckiN20a1R4JEkuXmPP77k/3U3RK4hPQI+LFT2EFwid0NrfRdwkJj2
	zb7uPzvOk6ewr3hBiKzKHZwUyPRh3uk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-nsswVTfqO727B09gdM56XA-1; Thu,
 06 Jun 2024 11:38:43 -0400
X-MC-Unique: nsswVTfqO727B09gdM56XA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9CCA19344B7;
	Thu,  6 Jun 2024 15:38:41 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BFD521955F4B;
	Thu,  6 Jun 2024 15:38:39 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:38 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 03/15] libtracefs: prevent a memory leak in update_fields()
Date: Thu,  6 Jun 2024 17:38:17 +0200
Message-ID: <20240606153830.2666120-4-jmarchan@redhat.com>
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

In update_fields() p isn't freed is store_str fails. Since p is to be
freed whatever the result of store_str() might be, move the call to
free() before checking field_name.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index ecf09ce..c7b9eff 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -810,9 +810,9 @@ static int update_fields(struct tep_handle *tep,
 			if (!p)
 				return -1;
 			field_name = store_str(sb, p);
+			free((char *)p);
 			if (!field_name)
 				return -1;
-			free((char *)p);
 		}
 
 		tfield = tep_find_any_field(event, field_name);
-- 
2.44.0

