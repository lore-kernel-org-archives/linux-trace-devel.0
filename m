Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36B1148317
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594899; cv=none; b=eh7hqUOkEYIvrcKFJpDftOw5dyZt0xF1hg86+HrFG+lNpoSeamu5XgsbOMUgLy2ZO0TmuublZRCIVaWc+XUNnZaUdo1fgck1eTzjpTleUJ6EopJdhwQm+4pPBgGYa7iB+ldVnABuNuBsq/xqKa1eonUXFGmZ/p0/zNK1v7BC70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594899; c=relaxed/simple;
	bh=BBlz553ogim245M8Wac7L4+ZWqsb9T/rFIyDTu5TNeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vk0j+TXBoQm7dbIs7nQUv205GgcK4FBJpHDIM/FFiP9IQuln3A1Ik76RzvxOYOGAGQFk5+rAkCLEjWcY25mGcW5NZ1HiO4Ufw2aAesvXf//3H3giL5rlxCldBZS6VjZ3mNsPxUzkR5v05zyeqtRWP6kSjJD2S9lEZVqOmjv6KIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TWZJbfA6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TWZJbfA6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+UNJdzkqR5zRCkmYfdcwa/zAkqcYBb3xg2oIrVslVd8=;
	b=TWZJbfA65EYorLwAXwEK5oALLSr463swcTvad7SOzUxTlIEtLBE8cbc1k9NqWGT/82SCNM
	1M40Jothd3RJARPP7TUdM6o7zMzU5qNUFiOn3iF0DjRPC66HYUllyptnhJfIvXZXiz3Asa
	BZOHWEXxCFe37vFhRAuxBH+RXu4XjzE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-XvZOPoQbNryW0AszT9SCrg-1; Wed,
 05 Jun 2024 09:41:34 -0400
X-MC-Unique: XvZOPoQbNryW0AszT9SCrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF65329ABA03;
	Wed,  5 Jun 2024 13:41:33 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id D68511C0005E;
	Wed,  5 Jun 2024 13:41:31 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:31 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 09/38] trace-cmd lib: prevent a memory leak in read_ftrace_printk()
Date: Wed,  5 Jun 2024 15:40:24 +0200
Message-ID: <20240605134054.2626953-10-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Free path if out_write_section_header() fails.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4a9ecc5d..5ba0a145 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1214,8 +1214,10 @@ static int read_ftrace_printk(struct tracecmd_output *handle, bool compress)
 	if (compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_PRINTK, "printk", flags, true);
-	if (offset == (off_t)-1)
+	if (offset == (off_t)-1) {
+		put_tracing_file(path);
 		return -1;
+	}
 
 	out_compression_start(handle, compress);
 	ret = stat(path, &st);
-- 
2.44.0

