using System;
using System.Collections.Generic;
using System.Configuration;
using Microsoft.EntityFrameworkCore;

namespace SGTest.Models;

public partial class SgtestDatabaseContext : DbContext
{
    public SgtestDatabaseContext()
    {
    }

    public SgtestDatabaseContext(DbContextOptions<SgtestDatabaseContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Department> Departments { get; set; }

    public virtual DbSet<Employee> Employees { get; set; }

    public virtual DbSet<JobTitle> JobTitles { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        => optionsBuilder.UseNpgsql(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Department>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("Department_pkey");

            entity.ToTable("Department");

            entity.HasIndex(e => new { e.Name, e.ParentId }, "department_name_parentid_unique").IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.ManagerId).HasColumnName("ManagerID");
            entity.Property(e => e.Name).HasMaxLength(250);
            entity.Property(e => e.ParentId).HasColumnName("ParentID");
            entity.Property(e => e.Phone).HasMaxLength(100);

            entity.HasOne(d => d.Manager).WithMany(p => p.Departments)
                .HasForeignKey(d => d.ManagerId)
                .HasConstraintName("manager_fkey");

            entity.HasOne(d => d.Parent).WithMany(p => p.InverseParent)
                .HasForeignKey(d => d.ParentId)
                .HasConstraintName("parentId_fkey");
        });

        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("Employee_pkey");

            entity.ToTable("Employee");

            entity.HasIndex(e => e.FullName, "employee_fullname_unique").IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.FullName).HasMaxLength(255);
            entity.Property(e => e.Login).HasMaxLength(100);
            entity.Property(e => e.Password).HasMaxLength(255);

            entity.HasOne(d => d.DepartmentNavigation).WithMany(p => p.Employees)
                .HasForeignKey(d => d.Department)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("department_fkey");

            entity.HasOne(d => d.JobTitleNavigation).WithMany(p => p.Employees)
                .HasForeignKey(d => d.JobTitle)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("jobtitle");
        });

        modelBuilder.Entity<JobTitle>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("JobTitle_pkey");

            entity.ToTable("JobTitle");

            entity.HasIndex(e => e.Name, "jobtitle_name_unique").IsUnique();

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Name).HasMaxLength(250);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
