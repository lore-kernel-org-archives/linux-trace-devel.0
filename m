Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2A20124E
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188897; cv=none; b=sYQf/ljVmhNo5sVjBTIhcuHfVZWQp7XFjpOt4z1KDSHNZzGD2FzMy+dbvWNv+4NwuFQQWjkoBB41ue7QGU0yfL0iP8eZSfKA5eVzl7qhGzdRMvVQey6pwYScnEAYECTvQOENDIC+XjY5pwh4G6A6LDQHSVnw16u+kJPx9GRcXcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188897; c=relaxed/simple;
	bh=VZxN4LbskOWon1VUFUedEZLQsJHIIgSyH6+8LS1aIZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocJbcL5p3gZI1fDzILMedE5+MhGoGTOpwUrIprSTXCcaiHhSFYAFh8o7ITu4JUQxOiMuC7hFs+1PZJwJTZH1nFZNXp/oLrZJ1XW3jDFWIHYsUcdA4zO+nXQ+CS2GsbQgy8G81dA9VvFP+ru9ub8q7sfG7Y2nSnsy1YuO7OrxPso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fl3kiret; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fl3kiret"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WvBiEf0z8FYIvswQybNZaHNzUUCmJuFl+idRkfxYHs=;
	b=Fl3kiretZb02Izsmd2gdC9y9BqQmfcCDgsZOWEufWeR2Y6ZHCWHvlYu3ZWcOoO9gVXCmOi
	7c6i6PUkn2Mb3DW7MkZo9VP20UvZJ4T9qkzI+6lusZS1pqYt5nW31fpMyJ33ex2fzuuPfT
	ZJxyhjZxi+Zx4MOvZN/GMzsOrt+yDmo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-269-eb7ryV0OOneeVde3K8FWNA-1; Tue,
 29 Oct 2024 04:01:32 -0400
X-MC-Unique: eb7ryV0OOneeVde3K8FWNA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE81019560A5;
	Tue, 29 Oct 2024 08:01:31 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BD71A195607C;
	Tue, 29 Oct 2024 08:01:29 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:28 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 3/8] trace-cmd lib: Check the return value of do_lseek() in trace_get_options()
Date: Tue, 29 Oct 2024 09:01:12 +0100
Message-ID: <20241029080117.625177-4-jmarchan@redhat.com>
In-Reply-To: <20241029080117.625177-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20241029080117.625177-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Check that do_lseek doesn't fail before calling malloc() with a -1
argument.

This is flagged as an overrun error (CWE-119) by static anaysis
because of the call to read() later, but I don't imagine that malloc
would succeed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 66e11ddc..8bc9325c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2070,6 +2070,8 @@ __hidden void *trace_get_options(struct tracecmd_output *handle, size_t *len)
 	}
 
 	offset = do_lseek(&out_handle, 0, SEEK_CUR);
+	if (offset == (off_t)-1)
+		goto out;
 	buf = malloc(offset);
 	if (!buf)
 		goto out;
-- 
2.47.0

